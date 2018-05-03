server:
  addr: ":5001"
 
token:
  issuer: "{{ getenv "REGISTRY_AUTH_ISSUER" "Example issuer" }}"
  expiration: {{ getenv "REGISTRY_AUTH_EXPIRATION" "3600" }}
  certificate: "{{ getenv "REGISTRY_AUTH_CERT" }}"
  key: "{{ getenv "REGISTRY_AUTH_KEY" }}"

{{ if getenv "REGISTRY_AUTH_CALLBACK" }}
ext_auth:
  command: "auth"
{{ end }}

{{ if getenv "REGISTRY_AUTH_CALLBACK" }}
ext_authz:
  command: "auth"
{{ end }}