# Team Contribution

## Division of work

| Area | Owner | Notes |
|------|-------|-------|
| Dockerfiles, Compose, app stack hardening | Ali / team Docker track | Multi-stage frontend, API replicas, healthchecks, loopback binds |
| Ansible roles & automation | Ali / team Ansible track | `common`, `docker`, `nginx`, `app`, `ssl`, `proxy`, `evidence` |
| Nginx + SSL design | Shared | Host reverse proxy, self-signed SAN cert, HTTPS redirect |
| Documentation & evidence | Shared | `md/`, `results/`, README |

## Per-member notes

### Ali

- Refactored Compose to a single Nginx-free `docker-compose.yml` with loopback publishes
- Fixed backend dependency correctness (`mongodb` direct dependency, env-driven CORS)
- Built role-based Ansible project and deployed end-to-end to `vm1` (`192.168.31.104`)
- Resolved apt CDROM repository breakage on the Ubuntu VM
- Wired evidence collection into `results/` and documentation into `md/`

### Teammates (fill in names as applicable)

- Code review of Compose / Nginx / Ansible
- Assignment packaging and submission naming
- Cross-checking HTTP→HTTPS redirect and `/api/` load balancing from a second client

## Challenges faced

- Reconciling assignment “host Nginx” requirements with an existing Compose Nginx service
- Docker/UFW interaction on published ports
- Low-memory frontend builds on a 2 GB VM
- Keeping secrets out of version control while still automating `.env` creation

> Update names and bullets here before final submission so `team_contribution.md` matches actual team roster.
