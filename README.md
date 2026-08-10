# DaneshkarTeamProject — Automated Web App Deployment

DevOps team project (HW_L5_03): deploy a React + Express + MongoDB application with Docker Compose, expose it through host Nginx with self-signed TLS, and automate the full lifecycle with Ansible roles.

## Prerequisites

- Ubuntu 22.04 target (tested: `192.168.31.104`, SSH alias `vm1`)
- Ansible 2.16+ on the controller with collections:
  - `community.docker`
  - `community.crypto`
  - `community.general`
  - `ansible.posix`
- SSH key access to the target; sudo password available for `--ask-become-pass`

## Quick start

```bash
# 1. Secrets
cp ansible/group_vars/all/secrets.yml.example ansible/group_vars/all/secrets.yml
# edit passwords

# 2. Deploy everything
cd ansible
ansible-playbook site.yml --ask-become-pass

# 3. Map domain on your laptop
echo '192.168.31.104 myapp.local' | sudo tee -a /etc/hosts

# 4. Verify
curl -I http://myapp.local/          # 301 → https
curl -kI https://myapp.local/        # 200
curl -k https://myapp.local/api/users
```

## Project structure

```
.
├── ansible/                 # Inventory, playbooks, roles
│   ├── site.yml             # Full pipeline entry point
│   ├── server_setup.yml
│   ├── deploy_app.yml
│   ├── deploy_nginx.yml
│   ├── group_vars/all/
│   └── roles/{common,docker,nginx,app,ssl,proxy,evidence}/
├── backend/                 # Express API + Dockerfile
├── frontend/                # React SPA + multi-stage Dockerfile
├── docker-compose.yml       # App stack (no Nginx; loopback ports)
├── md/                      # Markdown deliverables
├── results/                 # Command/playbook output artifacts
├── scripts/collect_evidence.sh
└── README.md
```

## Configuration

| Variable / file | Purpose |
|-----------------|---------|
| `ansible/group_vars/all/main.yml` | Domain, paths, ports, `tls_enabled` |
| `ansible/group_vars/all/secrets.yml` | DB / mongo-express passwords (gitignored) |
| `.env` on server (`/opt/myapp/.env`) | Consumed by Compose |
| `/etc/nginx/sites-available/myapp.local` | Reverse proxy + TLS |

## Usage

| Goal | Command |
|------|---------|
| Full deploy | `ansible-playbook site.yml --ask-become-pass` |
| Prep server only | `ansible-playbook server_setup.yml --ask-become-pass` |
| Redeploy app | `ansible-playbook deploy_app.yml --ask-become-pass` |
| Redeploy Nginx/SSL | `ansible-playbook deploy_nginx.yml --ask-become-pass` |
| Collect extra evidence | `scripts/collect_evidence.sh` |

## Endpoints

| URL | Result |
|-----|--------|
| `http://myapp.local/` | 301 redirect to HTTPS |
| `https://myapp.local/` | React UI |
| `https://myapp.local/api/users` | JSON API (load-balanced) |
| `https://myapp.local/mongo/` | mongo-express (HTTP basic auth) |

## Troubleshooting

See [md/troubleshooting.md](md/troubleshooting.md). Common issues: apt CDROM sources, Nginx 502 (containers down), self-signed cert warnings (`curl -k`), Docker publishing bypassing UFW (use loopback binds).

## Documentation index

- [Architecture](md/architecture.md)
- [Deployment guide](md/deployment_guide.md)
- [Project info](md/project_info.md)
- [Dockerfile explanation](md/dockerfile_explanation.md)
- [Compose explanation](md/compose_explanation.md)
- [Nginx explanation](md/nginx_explanation.md)
- [Server info](md/server_info.md)
- [Project summary](md/project_summary.md)
- [Team contribution](md/team_contribution.md)
