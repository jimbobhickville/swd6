import flask
import flask_cors
from sqlalchemy_jsonapi import flaskext as flask_jsonapi
import logging

from swd6.config import CONF
from swd6.db.models import db

logging.basicConfig(level=logging.DEBUG)

app = flask.Flask(__name__)
app.config['DEBUG'] = True
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
app.config['SQLALCHEMY_DATABASE_URI'] = CONF.db.uri
app.config['SERVER_NAME'] = CONF.api.host

app.logger.setLevel(logging.DEBUG)

flask_cors.CORS(app, origins=CONF.api.cors_hosts)

logging.getLogger('flask_cors').level = logging.DEBUG

db.init_app(app)

api = flask_jsonapi.FlaskJSONAPI(app, db)
