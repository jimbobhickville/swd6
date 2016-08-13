FROM node:6.3.1-slim
ADD . /opt/swd6/ui

ENV UI_PORT=9090
ENV ENVIRONMENT=development

WORKDIR /opt/swd6/ui
RUN npm i
CMD ./node_modules/.bin/ng server --port $UI_PORT --environment $ENVIRONMENT
