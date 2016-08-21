FROM python:3.5.2
ADD . /opt/swd6/api

ENV API_PORT=8080
ENV API_HOST=localhost
ENV WORKER_COUNT=4

WORKDIR /opt/swd6/api
RUN pip install -e /opt/swd6/api
RUN pip install --upgrade git+https://github.com/jimbobhickville/sqlalchemy-jsonapi.git@sanity#egg=sqlalchemy_jsonapi
RUN pip install --upgrade simplejson
CMD gunicorn -w $WORKER_COUNT -b 0.0.0.0:$API_PORT swd6.api.app:app
