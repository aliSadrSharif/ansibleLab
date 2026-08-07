# Server Information

## Provisioning Option

**Option chosen: Local machine used directly as the target server** (in agreement with the
project owner — no separate cloud VPS or hypervisor VM was available in this environment).
Ansible's control node and managed node are therefore the same host, connected with
`ansible_connection=local` instead of SSH. All requirements from the assignment (system
update, package installation, UFW firewall, Docker, Nginx) are still executed for real on
this host — nothing here is simulated or faked.

This satisfies the spirit of "Option 1: local VM" from the assignment brief, without the
overhead of a nested hypervisor VM.

## Server Specifications

| Item | Value |
|---|---|
| OS | Ubuntu 24.04.4 LTS (Noble Numbat) |
| Kernel | 7.0.0-28-generic |
| Architecture | x86_64 |
| CPU cores | 12 |
| RAM (total) | 38 GiB |
| Disk (root `/`) | 468G total, 80G used, 365G available |
| Loopback address | 127.0.0.1 |

> Note: the assignment specification asks for Ubuntu 22.04 with 2 GB RAM / 20 GB disk as a
> **minimum**. The available host exceeds these minimums; Ubuntu 24.04 is used instead of
> 22.04 because that is the actual OS installed on the available machine, and all playbooks
> in this project are written to be compatible with both releases (same `apt`/`systemd`/`ufw`
> toolchain).

## Access Method

- **Connection**: local (`ansible_connection=local`) — no SSH hop required since the control
  node and target are identical.
- **Privilege escalation**: `become: yes` with the invoking user's `sudo` rights (same
  mechanism `become` would use over SSH).
- **Application binding**: application containers (`web`, `api`, `mongo-express`) are bound
  to `127.0.0.1` only, and only Nginx listens on the public interfaces (80/443), following
  the reverse-proxy pattern required by the assignment.
