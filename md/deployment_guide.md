# Deployment Guide

## Prerequisites

- Controller with Ansible 2.16+ and collections: `community.docker`, `community.crypto`, `community.general`, `ansible.posix`
- SSH access to the target (`ssh vm1` → `tantan@192.168.31.104`)
- sudo password on the target (`--ask-become-pass`)
- Copy secrets template:

```bash
cp ansible/group_vars/all/secrets.yml.example ansible/group_vars/all/secrets.yml
# edit passwords
```

## One-shot deploy

```bash
cd ansible
ansible-playbook site.yml --ask-become-pass
```

This will:

1. Disable broken CDROM apt sources, update packages, install curl/wget/git/vim/htop/ufw/rsync
2. Configure UFW for 22/80/443
3. Install Docker CE + Compose plugin; add `tantan` to `docker` group
4. Install and enable Nginx
5. Rsync the project to `/opt/myapp`, write `.env`, `docker compose build/up`
6. Generate a self-signed cert with SAN `DNS:myapp.local`
7. Deploy Nginx site config, enable it, disable default, reload
8. Collect evidence into `results/`

## Partial runs

```bash
ansible-playbook server_setup.yml --ask-become-pass
ansible-playbook deploy_app.yml --ask-become-pass
ansible-playbook deploy_nginx.yml --ask-become-pass
```

## Local DNS

On the controller:

```bash
# /etc/hosts
192.168.31.104 myapp.local
```

## Expected verification

```bash
curl -I http://myapp.local/
# HTTP/1.1 301 Moved Permanently → https://myapp.local/

curl -kI https://myapp.local/
# HTTP/1.1 200 OK

curl -k https://myapp.local/api/users
# [] or JSON array

curl -kI https://myapp.local/mongo/
# HTTP/1.1 401 Unauthorized (basic auth)
```

## Collect remaining controller-side evidence

```bash
cd ansible
../scripts/collect_evidence.sh
```

## Application directory on server

`/opt/myapp` — owned by `tantan`, contains Compose file, Dockerfiles, source, and `.env`.
