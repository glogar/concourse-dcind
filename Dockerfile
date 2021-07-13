# https://hub.docker.com/_/alpine
# https://docs.docker.com/engine/release-notes/
# https://docs.docker.com/compose/release-notes/ or https://pypi.org/project/docker-compose/
# https://pypi.org/project/docker-squash/

FROM alpine:3.14

ENV DOCKER_CHANNEL=stable \
    DOCKER_VERSION=20.10.7 \
    DOCKER_COMPOSE_VERSION=1.29.2 \
    DOCKER_SQUASH=1.0.8

# Install Docker, Docker Compose, Docker Squash
RUN set -ex \
        && apk add --no-cache --virtual .build-deps \
            curl \
            gcc \
            musl-dev \
            python3-dev \
            libffi-dev \
            openssl-dev \
            cargo \
            py3-pip \
            make \
            # ca-certificates \
            # device-mapper \
            # git \
            # less \
            # libc-dev \
            # libressl-dev \
            # openssh \
            # python3 \
            # util-linux \
        && apk add --no-cache --virtual .run-deps \
            bash \
            iptables \
        && apk upgrade \
        && curl -fL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" | tar zx \
        && mv /docker/* /bin/ \
        && chmod +x /bin/docker* \
        && python3 -m pip install --upgrade pip \
        && pip3 install --no-cache-dir setuptools_rust \
        && pip3 install --no-cache-dir docker-compose==${DOCKER_COMPOSE_VERSION} \
        && pip3 install --no-cache-dir docker-squash==${DOCKER_SQUASH} \
        && apk del .build-deps \
        && rm -rf /var/lib/apt/lists/* \
        && rm -rf /var/cache/apk/* \
        && rm -rf /root/.cache

COPY entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
