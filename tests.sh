#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

image=$1

cid="$(docker run -d --name "docker_auth" "${image}")"
trap "docker rm -vf $cid > /dev/null" EXIT

docker_auth() {
	docker run --rm -i --link "docker_auth":"docker_auth" "${image}" "${@}"
}

echo -n "Waiting for Docker auth to start... "
docker_auth make check-ready wait_seconds=5 max_try=12 delay_seconds=5 host="docker_auth"
echo "OK"
