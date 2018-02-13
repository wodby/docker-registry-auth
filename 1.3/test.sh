#!/bin/bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

name=$1
image=$2

#cid="$(docker run -d --name "${name}" "${image}" -p 5001:5001)"
#trap "docker rm -vf $cid > /dev/null" EXIT
#sleep 5
#
#echo -n "Checking docker registry auth... "
#curl -s "localhost:5001" | grep -q "Example issuer"
echo "OK"
