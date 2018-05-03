#!/bin/sh

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

init_certificates() {
    local dir="${DOCKER_AUTH_CONF_DIR}"

    if [[ -z "${REGISTRY_AUTH_CERT}" ]]; then
        export REGISTRY_AUTH_CERT="${dir}/server.crt"
    fi

    if [[ -z "${REGISTRY_AUTH_KEY}" ]]; then
        export REGISTRY_AUTH_KEY="${dir}/server.key"
    fi

    if [[ ! -f "${REGISTRY_AUTH_CERT}" && ! -f "${REGISTRY_AUTH_KEY}" ]]; then
        echo "SSL certificates and key are missing, generating new"
        gen_ssl_certs "${dir}" "" "server"
        cat "${REGISTRY_AUTH_CERT}"
        echo ""
        echo ""
    fi
}

init_certificates

if [[ -n "${REGISTRY_AUTH_CALLBACK}" ]]; then
    gotpl /etc/gotpl/config.callback.yml.tpl > "${DOCKER_AUTH_CONF_DIR}/config.yml"
else
    if [[ -z "${REGISTRY_AUTH_ADMIN_PASSWORD}" ]]; then
        echo "Admin password is missing, generating automatically"
        export REGISTRY_AUTH_ADMIN_PASSWORD=$(htpasswd -bnBC 10 "" $(pwgen -s 32 1) | tr -d ':\n')
        echo "Generated admin password: ${REGISTRY_AUTH_ADMIN_PASSWORD}"
        echo ""
        echo ""
    fi

    gotpl /etc/gotpl/config.yml.tpl > "${DOCKER_AUTH_CONF_DIR}/config.yml"
fi

exec_init_scripts

if [[ "${1}" == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec $@
fi
