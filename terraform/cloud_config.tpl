#cloud-config

ssh_authorized_keys:
  - ${bootstrap_pubkey}
