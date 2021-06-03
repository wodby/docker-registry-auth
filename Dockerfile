ARG AUTH_SERVER_VER
ARG ALPINE_VER

FROM cesanta/docker_auth:${AUTH_SERVER_VER} as build

FROM wodby/alpine:${ALPINE_VER}

ENV DOCKER_AUTH_CONF_DIR="/etc/docker_auth" \
    DOCKER_AUTH_CERTS_DIR="/etc/docker_auth/certs"

RUN set -xe; \
    \
    apk add --update --no-cache -t .run-deps \
        apache2-utils \
        curl \
        jq \
        libressl \
        make \
        pwgen; \
    \
    gotpl_url="https://github.com/wodby/gotpl/releases/download/0.3.3/gotpl-linux-amd64.tar.gz"; \
    wget -qO- "${gotpl_url}" | tar xz --no-same-owner -C /usr/local/bin; \
    \
    mkdir -p "${DOCKER_AUTH_CONF_DIR}" "${DOCKER_AUTH_CERTS_DIR}"

COPY --from=build /docker_auth/auth_server /usr/local/bin/auth_server

COPY templates /etc/gotpl/
COPY bin /usr/local/bin
COPY entrypoint.sh /

WORKDIR "${DOCKER_AUTH_CONF_DIR}"

EXPOSE 5001

ENTRYPOINT ["/entrypoint.sh"]

CMD ["auth_server", "--v=3", "--alsologtostderr", "/etc/docker_auth/config.yml"]