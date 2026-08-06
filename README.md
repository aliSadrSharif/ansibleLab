# AnsibleLab — Dockerized Web App Deployment with Nginx, SSL/TLS and Ansible

A full-stack **user directory** app (React + Express + MongoDB) deployed with Docker
Compose, published through a system-level Nginx reverse proxy with a self-signed TLS
certificate, and fully automated end-to-end with Ansible.

## Project Description

- **Frontend** (`frontend/`): React SPA, multi-stage Docker build, served via `serve`.
- **Backend** (`backend/`): Express REST API (`/users`), talks to MongoDB.
- **Database**: MongoDB 4.4 + Mongo Express admin UI, both internal-only (loopback / no
  public port).
- **Reverse proxy**: system Nginx terminates TLS and routes `/`, `/api/`, `/mongo/` to the
  corresponding container.
- **Automation**: Ansible playbooks provision the host, deploy the stack, and configure
  Nginx + SSL — all idempotent, all re-runnable.

See `09_documentation/architecture.md` for a full diagram and `01_environment/` through
`10_delivery/` for the numbered, stage-by-stage deliverables this assignment requires.

## Prerequisites

- Ubuntu 22.04+ host (or any systemd-based Debian derivative)
- `sudo`/root access on the target host
- Ansible ≥ 2.15 with the `community.docker`, `community.crypto`, and `community.general`
  collections (`ansible-galaxy collection install community.docker community.crypto
  community.general`)
- Docker Engine + Docker Compose plugin (installed automatically by
  `02_ansible_setup/server_setup.yml` if missing)

## Installation

```bash
git clone https://github.com/aliSadrSharif/ansibleLab.git
cd ansibleLab
cp .env.example .env        # fill in real MongoDB / Mongo Express credentials
```

## Usage

### Option A — one-command full automation (recommended)

```bash
cd 08_ansible_automation
ansible-playbook -i ../02_ansible_setup/inventory site.yml
```

This provisions the server (packages, UFW, Docker, Nginx), deploys the application to
`/opt/myapp` with Docker Compose, and configures Nginx with a self-signed certificate for
`myapp.local`. Add `127.0.0.1 myapp.local` to `/etc/hosts` if the playbook didn't already
do it for your target, then browse to `https://myapp.local`.

### Option B — manual, step by step

```bash
docker compose build
docker compose up -d
docker compose ps
curl http://localhost:3000
curl http://localhost:3001/users
```

Then follow `06_nginx/` and `07_ssl/` to configure the reverse proxy and TLS manually.

## Project Structure

```
.
├── frontend/                  # React app (multi-stage Dockerfile)
├── backend/                   # Express API (Dockerfile)
├── docker-compose.yaml        # web + api + db + mongo-express
├── nginx/default.conf         # reference config for a REAL domain + Let's Encrypt
├── certbot.sh / openssl.sh    # helper scripts for real / self-signed certs
├── 01_environment/ .. 10_delivery/   # assignment deliverables, one folder per stage
└── 09_documentation/          # architecture, deployment guide, troubleshooting
```

See `09_documentation/deployment_guide.md` for step-by-step commands and expected output,
and `09_documentation/troubleshooting.md` for common issues.
