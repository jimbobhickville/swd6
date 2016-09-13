import logging
import os

import flask
import flask_cors
from sqlalchemy_jsonapi import flaskext as flask_jsonapi

from swd6 import config
from swd6.db.models import db

CONF = config.CONF
DEFAULT_CONF_PATH = '/opt/swd6/api/api.conf'
app = None


def start():
    #  pylint: disable=global-statement
    global app
    app = flask.Flask(__name__)
    app.config['DEBUG'] = True
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = CONF.db.uri
    app.config['SERVER_NAME'] = CONF.api.host

    app.logger.setLevel(logging.DEBUG)

    flask_cors.CORS(app, origins=CONF.api.cors_hosts)

    logging.getLogger('flask_cors').level = logging.DEBUG

    db.init_app(app)

    flask_jsonapi.FlaskJSONAPI(app, db, options={'dasherize': False, 'include_fk_columns': True})
    return app


logging.basicConfig(level=logging.DEBUG)
if os.path.exists(DEFAULT_CONF_PATH):
    config_files = [DEFAULT_CONF_PATH]
else:
    config_files = []

config.load([], default_config_files=config_files)

start()
