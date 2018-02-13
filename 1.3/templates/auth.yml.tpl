server:
  addr: "{{ getenv "REGISTRY_AUTH_ADDRESS" }}"
 
token:
  issuer: "{{ getenv "REGISTRY_AUTH_ISSUER" }}"
  expiration: {{ getenv "REGISTRY_AUTH_EXPIRATION" }}
  certificate: "{{ getenv "REGISTRY_AUTH_CERT" }}"
  key: "{{ getenv "REGISTRY_AUTH_KEY" }}"
 
users:
  {{ getenv "REGISTRY_AUTH_ADMIN_USER" }}: 
    password: "{{ getenv "REGISTRY_AUTH_ADMIN_PASSWORD" }}"
  {{ range jsonArray (getenv "REGISTRY_AUTH_USERS") }}{{ .username }}:
    password: "{{ .password }}"
  {{ end }}
 
acl:
  - match:
      account: "{{ getenv "REGISTRY_AUTH_ADMIN_USER" }}"
    actions: ["*"]
    comment: "Admin has full access to everything."
  {{ range jsonArray (getenv "REGISTRY_AUTH_USERS") }}- match:
      account: "{{ .username }}"
      name: "{{ .username }}/*"
    actions: ["*"]
    comment: "User can pull from his own namespace"
  {{ end }}
