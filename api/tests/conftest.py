import json
import logging
import socket
import time
from urllib.parse import urlparse

import docker as docker_client
from docker import errors as docker_exc
from flask import testing as flask_test
import pytest
from requests import exceptions as requests_exc
import sqlalchemy
from sqlalchemy import exc as sqla_exc

from swd6.api import app
from swd6 import config
from swd6.db import models

CONF = config.CONF


def pytest_addoption(parser):
    parser.addoption('--use-config-db', action='store_true', help="Use the database connection "
                                                                  "uri provided in the supplied "
                                                                  "config file rather than "
                                                                  "creating a fresh database.")
    parser.addoption('--save-db', action='store_true', help="Keep the test db container after "
                                                            "completion (useful for debugging "
                                                            "failures).")
    parser.addoption('--config-file', action='append', help="Path(s) to an config file(s) to use.")


@pytest.fixture(scope="session", autouse=True)
def log_setup():
    logging.basicConfig(level=logging.DEBUG)


@pytest.fixture(scope="session")
def docker():
    client = docker_client.from_env(assert_hostname=False)
    try:
        client.info()
    except requests_exc.ConnectionError:
        raise IOError("Cannot connect to docker, is docker running?")
    return client


@pytest.fixture(scope='session')
def docker_ip(docker):
    urlinfo = urlparse(docker.base_url)
    # looking through the docker-py code, this should cover all of the socket options
    if urlinfo.netloc == 'localunixsocket' or 'unix' in urlinfo.scheme:
        return 'localhost'
    else:
        return socket.getaddrinfo(urlinfo.hostname, urlinfo.port)[-1][-1][0]


@pytest.fixture(scope='session')
def container_network(request, docker):
    network_name = 'swd6_test_net'

    def cleanup():
        try:
            docker.remove_network(network_name)
        except docker_exc.NotFound:
            pass

    docker.create_network(network_name, 'bridge')

    if not request.config.getoption('--save-db'):
        request.addfinalizer(cleanup)

    return network_name


@pytest.fixture(scope='session')
def api_db(request, api_config, container_network, docker, docker_ip):
    if request.config.getoption('--use-config-db'):
        return models.db

    container_name = 'swd6_test_db'
    image_name = 'postgres:9.5.3'

    def cleanup():
        try:
            docker.remove_container(container_name, v=True, force=True)
        except docker_exc.NotFound:
            pass

    env = {
        'POSTGRES_USER': 'swd6',
        'POSTGRES_PASSWORD': 'swd6',
    }

    # make sure the image is downloaded so the create is instant
    for _ in docker.pull(image_name, stream=True):
        pass

    networking_config = docker.create_networking_config({
        container_network: {'Aliases': [container_name]}
    })
    host_config = docker.create_host_config(network_mode=container_network,
                                            port_bindings={'5432': None})
    created = docker.create_container(name=container_name,
                                      hostname='db',
                                      ports=[5432],
                                      image=image_name,
                                      host_config=host_config,
                                      networking_config=networking_config,
                                      environment=env)

    docker.start(created['Id'])

    if not request.config.getoption('--save-db'):
        request.addfinalizer(cleanup)

    db_container = docker.inspect_container(created['Id'])

    db_uri = "postgresql://{username}:{password}@{host}:{port}/{dbname}".format(
        username=env['POSTGRES_USER'],
        password=env['POSTGRES_PASSWORD'],
        host=docker_ip,
        port=db_container['NetworkSettings']['Ports']['5432/tcp'][0]['HostPort'],
        dbname='swd6',
    )

    api_config.set_override('uri', db_uri, group='db')

    # give psql some time to be functional
    attempts = 0
    engine = sqlalchemy.create_engine(db_uri, client_encoding='utf8')
    while True:
        try:
            connection = engine.connect()
            connection.execute('CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public')
            break
        except sqla_exc.OperationalError:
            attempts += 1
            if attempts < 240:
                time.sleep(0.25)
            else:
                raise

    return models.db


@pytest.fixture(scope='session', autouse=True)
def api_config(request):
    config.load([], default_config_files=request.config.getoption('--config-file'))
    return config.CONF


@pytest.fixture(scope='session')
def api_app(api_db):
    test_app = app.start()
    test_app.testing = True

    api_db.create_all(app=test_app)

    return test_app


@pytest.fixture(scope='session')
def api_client(api_app):
    api_app.test_client_class = JSONAPIClient
    return api_app.test_client()


@pytest.yield_fixture(autouse=True)
def context(api_app, api_db):
    with api_app.app_context() as ctx:
        # automatically roll back any changes from each test case, but keep any initial state set
        # up by global fixtures
        outer = api_db.session.begin_nested()
        api_db.session.begin_nested()
        try:
            yield ctx
        finally:
            if outer.is_active:
                outer.rollback()


@pytest.fixture(scope='function')
def test_attribute(context):
    attribute = models.Attribute(id='Tes', name='Test Attribute', display_order=0)
    with models.db.session.begin_nested():
        models.db.session.add(attribute)
    return attribute


@pytest.fixture(scope='function')
def test_planet(context):
    planet = models.Planet(name='Test Planet')
    with models.db.session.begin_nested():
        models.db.session.add(planet)
    return planet


class JSONAPIClient(flask_test.FlaskClient):
    def open(self, *args, **kwargs):
        kwargs['path'] = '/api/{}'.format(kwargs['path'])
        if 'data' in kwargs and isinstance(kwargs['data'], dict):
            kwargs['data'] = json.dumps(kwargs['data'])

        if 'content_type' not in kwargs:
            kwargs['content_type'] = 'application/vnd.api+json'

        response = super(JSONAPIClient, self).open(*args, **kwargs)
        return json.loads(response.data.decode('utf8'))
