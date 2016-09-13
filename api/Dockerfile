FROM python:3.5.2-slim
ADD . /opt/swd6/api

ENV API_PORT=8080
ENV API_HOST=localhost
ENV WORKER_COUNT=4

WORKDIR /opt/swd6/api
RUN apt-get clean \
    && apt-get update \
    && apt-get install -y build-essential libpq-dev libpq5 git \
    && pip install -e /opt/swd6/api \
    && pip install --upgrade git+https://github.com/jimbobhickville/sqlalchemy-jsonapi.git@sanity#egg=sqlalchemy_jsonapi \
    && pip install --upgrade simplejson \
    && apt-get -y purge build-essential libpq-dev git \
    && apt-get autoremove -y \
    && apt-get clean

CMD gunicorn -w $WORKER_COUNT -b 0.0.0.0:$API_PORT swd6.api.app:app
