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
RUN apk update \
    && apk upgrade \
    && apk --update --no-cache add \
        bash \
        ca-certificates \
        cargo \
        curl \
        device-mapper \
        gcc \
        git \
        iptables \
        less \
        libc-dev \
        libffi-dev \
        libressl-dev \
        make \
        musl-dev \
        openssh \
        openssl-dev \
        py3-pip \
        python3 \
        python3-dev \
        util-linux \
    && curl -fL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" | tar zx \
    && mv /docker/* /bin/ && chmod +x /bin/docker* \
    && python3 -m pip install --upgrade pip \
    && pip3 install docker-compose==${DOCKER_COMPOSE_VERSION} \
    && pip3 install docker-squash==${DOCKER_SQUASH} \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apk/* \
    && rm -rf /root/.cache

COPY entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
