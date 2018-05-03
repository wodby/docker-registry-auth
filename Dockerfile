ARG AUTH_SERVER_VER

FROM cesanta/docker_auth:${AUTH_SERVER_VER} as build

FROM wodby/alpine:3.7-2.0.1

ENV GOTPL_VER="0.1.5" \
    DOCKER_AUTH_CONF_DIR="/mnt/config"

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
    gotpl_url="https://github.com/wodby/gotpl/releases/download/${GOTPL_VER}/gotpl-alpine-linux-amd64-${GOTPL_VER}.tar.gz"; \
    wget -qO- "${gotpl_url}" | tar xz -C /usr/local/bin; \
    \
    mkdir -p "${DOCKER_AUTH_CONF_DIR}"

COPY --from=build /docker_auth/auth_server /usr/local/bin/auth_server

COPY templates /etc/gotpl/
COPY bin /usr/local/bin
COPY entrypoint.sh /

VOLUME /mnt/config

EXPOSE 5001

ENTRYPOINT ["/entrypoint.sh"]

CMD ["auth_server", "--v=3", "--alsologtostderr", "/mnt/config/config.yml"]