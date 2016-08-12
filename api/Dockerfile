FROM python:3.5.2
ADD . /opt/swd6
WORKDIR /opt/swd6
RUN pip install -e /opt/swd6
CMD gunicorn -w $WORKER_COUNT -b 0.0.0.0:$API_PORT swd6.api.app:app
