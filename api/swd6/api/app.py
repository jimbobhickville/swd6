import logging
import sys

import flask
import flask_cors
from sqlalchemy_jsonapi import flaskext as flask_jsonapi

from swd6 import config
from swd6.db.models import db

CONF = config.CONF
api = None


def setup():
    app = flask.Flask(__name__)
    app.config['DEBUG'] = True
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = CONF.db.uri
    app.config['SERVER_NAME'] = CONF.api.host

    app.logger.setLevel(logging.DEBUG)

    flask_cors.CORS(app, origins=CONF.api.cors_hosts)

    logging.getLogger('flask_cors').level = logging.DEBUG

    db.init_app(app)

    flask_jsonapi.FlaskJSONAPI(app, db, options={'dasherize': False})
    return app


def start():
    #  pylint: disable=global-statement
    global api
    api = setup()
    return api


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    config.load(sys.argv[1:], default_config_files=['/opt/swd6/api.conf'])
    start()
