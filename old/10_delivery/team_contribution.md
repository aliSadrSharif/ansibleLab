# Team Contribution

## Work Split

| Area | Owner |
|---|---|
| Application (React frontend, Express backend, MongoDB schema) | Ali Sadr Sharif |
| Docker (Dockerfiles, docker-compose.yaml, image hardening) | Kiarash Naderi |
| Ansible (server provisioning, app deployment, Nginx/SSL automation) | Kiarash Naderi |
| Nginx / SSL configuration | Kiarash Naderi |
| Documentation (README, architecture, deployment guide, troubleshooting) | Kiarash Naderi |

This matches the assignment's suggestion to split Docker and Ansible ownership between
team members, building on top of the application already authored by Ali Sadr Sharif.

## Contribution — Ali Sadr Sharif

- Built the original full-stack application: React frontend (`frontend/`), Express REST
  API (`backend/`), and the initial Docker/Nginx/docker-compose scaffolding this project
  builds on (see `git log` commits before this branch).

## Contribution — Kiarash Naderi

- Provisioned the target host with Ansible (`02_ansible_setup/server_setup.yml`):
  packages, UFW firewall, Docker, Nginx.
- Hardened both Dockerfiles (non-root users, multi-stage frontend build, health checks)
  and reworked `docker-compose.yaml` (secrets via `.env`, no exposed DB port, health
  checks, restart policies).
- Removed the containerized Nginx service in favor of a system-level reverse proxy;
  authored and deployed the Nginx configuration (`06_nginx/`).
- Generated and deployed the self-signed TLS certificate and HTTPS redirect (`07_ssl/`).
- Authored the full Ansible automation layer (`08_ansible_automation/`) — `deploy_app.yml`,
  `deploy_nginx.yml`, `site.yml`, and the Nginx Jinja2 template — and ran it end-to-end
  against a real target.
- Wrote all project documentation (`README.md`, `09_documentation/`) and the numbered
  deliverable evidence for every stage (`01_environment/` through `10_delivery/`).

## Challenges — Kiarash Naderi

- No dedicated VPS/VM was available for the assignment's "target server" — required
  adapting the Ansible inventory to target the local host safely (scoped, temporary sudo
  automation access) instead of skipping the automation requirement.
- Reconciling the assignment's system-level Nginx model with the repo's original
  containerized-Nginx design without breaking the already-working app.
