# docker-compose.yaml Explanation

> Note: `04_docker/docker-compose.yml` is a snapshot copy of the real, working file at the
> repository root (`docker-compose.yaml`) — that root file is the single source of truth
> that is actually built/run/deployed.

## Services

- **web** — the React frontend (multi-stage build). Published only on
  `127.0.0.1:3000` — not reachable from outside the host directly; only the system Nginx
  (public on 80/443) can reach it.
- **api** — the Express backend. Published only on `127.0.0.1:3001`. Reads Mongo
  credentials from `${MONGO_ROOT_USER}` / `${MONGO_ROOT_PASSWORD}`, resolved from the
  git-ignored `.env` file (see `.env.example`) — no secrets are hardcoded or committed.
- **db** — MongoDB. Uses `expose: ["27017"]` instead of `ports:`, so it is reachable from
  other containers on the compose network (`api`, `mongo-express`) but **not** published to
  the host or the internet — a direct fix of the original insecure `ports: 27017:27017`.
- **mongo-express** — web UI for MongoDB, protected by HTTP basic auth, published only on
  `127.0.0.1:8081`.

## Requirements covered

| Requirement | How it's met |
|---|---|
| Web application service | `web` |
| Database service | `db` |
| Network | default compose bridge network (implicit) connects all 4 services |
| Volumes / persistence | named volume `mongodb-data` for `/data/db` |
| Environment variables | `.env` file, referenced via `${VAR}` interpolation |
| Port mapping | loopback-only for app services, public only via system Nginx |
| Dependencies between services | `depends_on: db: condition: service_healthy` on `api` and `mongo-express` |
| Restart policies | `restart: unless-stopped` on every service |
| Health checks | `healthcheck:` block on `web`, `api`, `db` |

## Why no containerized Nginx service

The original draft of this file included a `nginx` container publishing 80/443 with a
hardcoded `domain.com` config. This assignment's Stage 6/7/8 explicitly describe a
**system-level** Nginx managed with `systemctl`, `/etc/nginx/sites-available`, and Ansible's
`template`/`file` modules — not a Dockerized one. Running both would double-bind ports
80/443 and conflict. The containerized `nginx` service was removed; the system Nginx
(installed in `02_ansible_setup/server_setup.yml`, configured in `06_nginx/` and
`08_ansible_automation/`) is the actual reverse proxy in front of `web`/`api`/`mongo-express`.
