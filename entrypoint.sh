#!/bin/sh

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

generate_certificate() {
    local dir="${DOCKER_AUTH_CONF_DIR}"

    if [[ -z "${REGISTRY_AUTH_CERT}" ]]; then
        export REGISTRY_AUTH_CERT="${dir}/server.crt"
    fi

    if [[ -z "${REGISTRY_AUTH_KEY}" ]]; then
        export REGISTRY_AUTH_KEY="${dir}/server.key"
    fi

    if [[ ! -f "${REGISTRY_AUTH_CERT}" && ! -f "${REGISTRY_AUTH_KEY}" ]]; then
        echo "SSL certificate and key are missing, generating new"
        gen_ssl_certs "${dir}" "" "server"
        cat "${REGISTRY_AUTH_CERT}"
        echo ""
        echo ""
    fi
}

generate_admin_password() {
    local pass_file="${DOCKER_AUTH_CONF_DIR}/.password"

    if [[ -f "${pass_file}" ]]; then
        local bcrypted_pass=$(cat "${pass_file}")
        export REGISTRY_AUTH_ADMIN_PASSWORD="${bcrypted_pass}"
    fi

    if [[ -z "${REGISTRY_AUTH_ADMIN_PASSWORD}" ]]; then
        echo "Admin password is missing, generating automatically"

        local pass=$(pwgen -s 32 1)
        local bcrypted_pass=$(htpasswd -bnBC 10 "" "${pass}" | tr -d ':\n')

        echo "${bcrypted_pass}" > "${pass_file}"
        export REGISTRY_AUTH_ADMIN_PASSWORD="${bcrypted_pass}"

        echo "Generated admin password: ${pass}"
        echo ""
        echo ""
    fi
}

generate_certificate

if [[ -n "${REGISTRY_AUTH_CALLBACK}" ]]; then
    gotpl /etc/gotpl/config.callback.yml.tpl > "${DOCKER_AUTH_CONF_DIR}/config.yml"
else
    generate_admin_password
    gotpl /etc/gotpl/config.yml.tpl > "${DOCKER_AUTH_CONF_DIR}/config.yml"
fi

exec_init_scripts

if [[ "${1}" == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec $@
fi
