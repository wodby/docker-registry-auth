server:
  addr: ":5001"
 
token:
  issuer: "{{ getenv "REGISTRY_AUTH_ISSUER" "Example issuer" }}"
  expiration: {{ getenv "REGISTRY_AUTH_EXPIRATION" "3600" }}
  certificate: "{{ getenv "REGISTRY_AUTH_CERT" }}"
  key: "{{ getenv "REGISTRY_AUTH_KEY" }}"

users:
  {{ getenv "REGISTRY_AUTH_ADMIN_USER" "admin" }}:
    password: "{{ getenv "REGISTRY_AUTH_ADMIN_PASSWORD" }}"
  {{ range jsonArray (getenv "REGISTRY_AUTH_USERS" "[]") }}{{ .username }}:
    password: "{{ .password }}"
  {{ end }}
{{ if getenv "REGISTRY_AUTH_ANON_PULL_ACCOUNT" }}
  "" : {}
{{ end }}

acl:
  - match:
      account: "{{ getenv "REGISTRY_AUTH_ADMIN_USER" "admin" }}"
    actions: ["*"]
    comment: "Admin has full access to everything."
  {{ range jsonArray (getenv "REGISTRY_AUTH_USERS" "[]") }}- match:
      account: "{{ .username }}"
      name: "{{ .username }}/*"
    actions: ["*"]
    comment: "User can pull from his own namespace"
  {{ end }}
{{ if getenv "REGISTRY_AUTH_ANON_PULL_ACCOUNT" }}- match:
      account: ""
    actions: ["pull"]
    name: {{ getenv "REGISTRY_AUTH_ANON_PULL_ACCOUNT" }}
{{ end }}