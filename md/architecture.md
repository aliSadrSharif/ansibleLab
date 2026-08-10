# Architecture

## Overview

```
                    ┌─────────────────────────────┐
                    │  Client (browser / curl)    │
                    │  https://myapp.local        │
                    └──────────────┬──────────────┘
                                   │ :443 TLS
                                   ▼
┌──────────────────────────────────────────────────────────┐
│  vm1 (192.168.31.104) — Ubuntu 22.04                     │
│                                                          │
│  ┌────────────────────────────────────────────────────┐  │
│  │ Host Nginx                                          │  │
│  │  :80  → 301 HTTPS                                   │  │
│  │  :443 → terminate TLS (self-signed)                 │  │
│  │     /        → 127.0.0.1:3000  (web)                │  │
│  │     /api/    → 127.0.0.1:3001-3003 (least_conn)     │  │
│  │     /mongo/  → 127.0.0.1:8081  (mongo-express)      │  │
│  └────────────────────────────────────────────────────┘  │
│                          │                               │
│  ┌───────────────────────┴────────────────────────────┐  │
│  │ Docker Compose (appnet) — loopback publishes only  │  │
│  │                                                    │  │
│  │  web          api-1   api-2   api-3                │  │
│  │   :3000        :3001   :3001   :3001               │  │
│  │                 \       |       /                  │  │
│  │                  \      |      /                   │  │
│  │                   ▼     ▼     ▼                    │  │
│  │                      db :27017                     │  │
│  │                       ▲                            │  │
│  │                       │                            │  │
│  │                 mongo-express :8081                │  │
│  └────────────────────────────────────────────────────┘  │
│                                                          │
│  UFW: allow 22, 80, 443 / deny other inbound             │
└──────────────────────────────────────────────────────────┘
```

## Components

| Component | Runs as | Responsibility |
|-----------|---------|----------------|
| Host Nginx | systemd | TLS, reverse proxy, load balance `/api/` |
| web | container | Static React SPA |
| api-* | containers | Express CRUD on `/users` |
| db | container | MongoDB persistence |
| mongo-express | container | DB browser behind basic auth |
| Ansible | controller | Provision + deploy + evidence |

## Request flow

1. Client resolves `myapp.local` → `192.168.31.104` via `/etc/hosts`.
2. HTTP hits Nginx `:80` and is redirected to HTTPS.
3. HTTPS is terminated with the self-signed cert under `/etc/nginx/ssl/`.
4. Path routing sends traffic to the matching loopback upstream.
5. API replicas talk to MongoDB on the internal Compose network.

## Automation flow

```
site.yml
  ├─ server_setup.yml  → roles: common, docker, nginx
  ├─ deploy_app.yml    → role: app  (rsync + compose up)
  ├─ deploy_nginx.yml  → roles: ssl, proxy
  └─ evidence          → role: evidence (results/ artifacts)
```
