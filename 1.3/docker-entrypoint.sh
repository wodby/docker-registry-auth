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

process_templates() {
    exec_tpl 'auth.yml.tpl' '/config/auth.yml'
}

process_templates

exec $@