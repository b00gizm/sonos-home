FROM hypriot/rpi-node:6.1-slim
MAINTAINER Pascal Cremer "b00gizm@gmail.com"

ENV GIT_TAG=master
ENV GIT_SOURCE="https://github.com/jishi/node-sonos-http-api/archive/${GIT_TAG}.zip"

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
        curl \
        unzip \
    && curl -L -o node-sonos-http-api.zip ${GIT_SOURCE} \
    && mkdir -p /srv \
    && unzip node-sonos-http-api.zip \
    && mv node-sonos-http-api-${GIT_TAG} /code \
    && cd /code \
    && npm install --production \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /code

EXPOSE 3500 5005

CMD ["npm", "start"]
