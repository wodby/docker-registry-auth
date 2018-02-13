FROM wodby/alpine:3.6-1.2.0

ENV DOCKER_AUTH_VER="1.3"

RUN set -xe; \
    \
    export GOPATH="/root/go"; \
    export GO_VER="1.8.4-r0"; \
    export PYTHON_VER="2.7.13-r1"; \
    export PIP_VER="9.0.1-r1"; \
    \
    apk add --update --no-cache -t .build-deps \
        git \
        make \
        musl-dev \
        "go=${GO_VER}" \
        "python2=${PYTHON_VER}" \
        "py2-pip=${PIP_VER}";  \
    \
    pip install gitpython; \
    \
    mkdir -p "${GOPATH}"; \
    export PATH="$PATH:$GOPATH/bin"; \
    \
    mkdir -p "${GOPATH}/src/github.com/cesanta"; \
    cd "${GOPATH}/src/github.com/cesanta"; \
    git clone --depth=50 https://github.com/cesanta/docker_auth.git; \
    cd ./docker_auth; \
    git checkout "tags/${DOCKER_AUTH_VER}"; \
    cd ./auth_server; \
    \
    go get -v -u github.com/kardianos/govendor; \
    govendor sync -v; \
    go install -v github.com/cesanta/docker_auth/auth_server/vendor/github.com/jteeuwen/go-bindata/go-bindata; \
    \
    make generate; \
    CGO_ENABLED=0 go build -v -i --ldflags=--s; \
    chmod 755 ./auth_server; \
    cp ./auth_server /usr/local/bin/; \
    \
    apk del --purge .build-deps; \
    rm -rf \
        /tmp/* \
        /usr/lib/python* \
        /root/go \
        /var/cache/apk/*;

COPY templates /etc/gotpl/
COPY docker-entrypoint.sh /

EXPOSE 5001

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["auth_server", "--v=3", "--alsologtostderr", "/config/auth.yml"]
