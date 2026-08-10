# Server Information

## Connection

| Field | Value |
|-------|-------|
| IP Address | `192.168.31.104` |
| Hostname (SSH alias) | `vm1` |
| Username | `tantan` |
| SSH access | Key-based via `~/.ssh/config` Host `vm1` (`ssh vm1`) |
| OS | Ubuntu 22.04.1 LTS |
| Kernel | 5.15.0-186-generic |

## System specs

| Resource | Value |
|----------|-------|
| CPU | 1 vCPU |
| RAM | 2 GB |
| Swap | 2 GB |
| Disk | 25 GB (`/dev/sda2`), ~18 GB free at provisioning time |

## Notes

- Privilege escalation (`sudo`) requires a password (`--ask-become-pass` / `--become-password-file`).
- Docker and Nginx were **not** pre-installed; both are provisioned by the Ansible `common` / `docker` / `nginx` roles.
- Domain used for reverse proxy: `myapp.local` (mapped in the controller `/etc/hosts` to `192.168.31.104`).
