#!/bin/sh

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

exec_tpl() {
    if [[ -f "/etc/gotpl/$1" ]]; then
        gotpl "/etc/gotpl/$1" > "$2"
    fi
}

printNotice() {
    printf "\n----------------------------------------------\n"
    printf "\n${1}\n"
    printf "\n----------------------------------------------\n"
}

generate_admin_password() {
    if [[ -n "${REGISTRY_AUTH_ADMIN_PASSWORD}" ]]; then
        echo "Admin password already specified"
        return 0
    fi

    local dir="/mnt/config"
    local pass_file="${dir}/.password"

    if [[ -f "${pass_file}" ]]; then
        local bcrypted_pass=`cat "${pass_file}"`
        export REGISTRY_AUTH_ADMIN_PASSWORD="${bcrypted_pass}"
        echo "Found stored admin password"
        return 0
    fi

    local pass=$(pwgen -s 32 1)
    local bcrypted_pass=$(htpasswd -bnBC 10 "" "${pass}" | tr -d ':\n')

    echo "${bcrypted_pass}" > "${pass_file}"
    export REGISTRY_AUTH_ADMIN_PASSWORD="${bcrypted_pass}"

    printNotice "Generated admin password: ${pass}"
}

generate_key() {
    local dir="/mnt/config"

    if [[ -z "${REGISTRY_AUTH_CERT}" ]]; then
        export REGISTRY_AUTH_CERT="${dir}/server.crt"
    fi

    if [[ -z "${REGISTRY_AUTH_KEY}" ]]; then
        export REGISTRY_AUTH_KEY="${dir}/server.key"
    fi

    if [[ -f "${REGISTRY_AUTH_CERT}" || -f "${REGISTRY_AUTH_KEY}" ]]; then
        echo "Found stored cert and/or key"
        return 0
    fi

    gen-ssl-certs.sh "${dir}" "" "server"

    local crt_content=`cat "${REGISTRY_AUTH_CERT}"`
    printNotice "Generated certificate:\n${crt_content}"
}

process_templates() {
    exec_tpl "config.yml.tpl" "/etc/docker-registry-auth/config.yaml"
}

generate_admin_password
generate_key
process_templates

exec $@
