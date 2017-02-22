#cloud-config

write_files:
  - path: /root/.vault-token
    permissions: 0644
    content: |
      ${vault_token}
