# Project Summary

## Challenges

1. **Host Nginx vs Compose Nginx** — The assignment requires apt Nginx with `sites-available`/`sites-enabled`, while the original stack ran Nginx in Compose on 80/443. Both cannot bind the same ports.
2. **Docker bypasses UFW** — Publishing container ports on `0.0.0.0` made mongo-express and APIs reachable from the LAN even with UFW deny.
3. **Broken apt CDROM source** — The VM’s `/etc/apt/sources.list` still referenced `file:///cdrom`, breaking `apt update` during Docker repo setup.
4. **mongo-express auth quirk** — `ME_CONFIG_MONGODB_SERVER` discards URL-based credentials.
5. **Low-RAM React build** — 1 vCPU / 2 GB required heap capping via `NODE_OPTIONS`.
6. **Module renames** — Assignment hints mention removed modules (`docker_compose`, `openssl_certificate`); current collections use `docker_compose_v2` and `x509_certificate`.

## Solutions

- Moved TLS termination and reverse proxy to **host Nginx**; Compose only runs app/db services on **loopback**.
- Consolidated to a single `docker-compose.yml` with health checks, anchors, and pinned mongo-express.
- Added Ansible `common` tasks to comment `file:/+cdrom` sources before any `update_cache`.
- Seven focused roles + `site.yml` import chain for full automation.
- Evidence role + `scripts/collect_evidence.sh` populate flat `results/` artifacts with stage-number prefixes.

## Lessons learned

- Align public exposure with the firewall model: if UFW is the gate, Docker must not publish on all interfaces.
- Prefer host reverse proxy when the grading rubric expects systemd Nginx workflows.
- Always verify SAN on self-signed certs; browsers ignore CN alone.
- Keep secrets out of git (`secrets.yml`, `.env`); commit only examples.

## Suggested improvements

- Ansible Vault instead of plaintext gitignored secrets for shared repos
- Let’s Encrypt if a real public DNS name becomes available
- CI pipeline that runs `ansible-playbook --syntax-check` and Compose config validation
- Centralized structured logging / metrics for the three API replicas
- Blue/green or rolling updates for API replicas without downtime
