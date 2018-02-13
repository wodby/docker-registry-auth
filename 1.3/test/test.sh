#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

docker-compose up -d

echo "Running check-ready action... "
docker-compose exec auth make check-ready max_try=10 wait_seconds=1 delay_seconds=1 -f /usr/local/bin/actions.mk
echo "OK"

docker-compose down
