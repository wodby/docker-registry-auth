server:
  addr: ":5001"

token:
  issuer: "{{ getenv "REGISTRY_AUTH_ISSUER" "Example issuer" }}"
  expiration: {{ getenv "REGISTRY_AUTH_EXPIRATION" "3600" }}
  certificate: "{{ getenv "REGISTRY_AUTH_CERT" }}"
  key: "{{ getenv "REGISTRY_AUTH_KEY" }}"

{{ if getenv "REGISTRY_AUTH_PUBLIC_PULL_ACCOUNT" }}
users:
  "" : {}

acl:
  - match:
      name: "{{ getenv "REGISTRY_AUTH_PUBLIC_PULL_ACCOUNT" }}"
    actions: ["pull"]
{{ end }}

ext_auth:
  command: "/usr/local/bin/ext_auth"

ext_authz:
  command: "/usr/local/bin/ext_authz"
