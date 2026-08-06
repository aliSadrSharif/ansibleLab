# Architecture

## Components

| Component | Role |
|---|---|
| Nginx (system service) | Public entry point, TLS termination, reverse proxy |
| web (Docker) | React frontend, static build served on 127.0.0.1:3000 |
| api (Docker) | Express REST API on 127.0.0.1:3001 |
| db (Docker) | MongoDB, internal network only (no host port) |
| mongo-express (Docker) | DB admin UI, basic-auth protected, 127.0.0.1:8081 |
| Ansible | Provisions the host and deploys/configures everything above |

## Diagram

```
                              Internet / LAN
                                    │
                                    │  HTTP :80 (redirect) / HTTPS :443
                                    ▼
                        ┌───────────────────────┐
                        │   Nginx (system svc)   │
                        │  TLS termination        │
                        │  myapp.local            │
                        └───────────┬─────────────┘
                                    │  proxy_pass (127.0.0.1)
              ┌─────────────────────┼─────────────────────┐
              │                     │                      │
              ▼                     ▼                      ▼
     location /            location /api/           location /mongo/
   ┌──────────────┐      ┌──────────────┐       ┌──────────────────┐
   │  web:3000     │      │  api:3001     │       │ mongo-express:8081│
   │  (React SPA)  │      │  (Express)    │       │  (admin UI)        │
   └──────────────┘      └───────┬──────┘       └─────────┬─────────┘
                                   │                          │
                                   └───────────┬──────────────┘
                                               ▼
                                     ┌──────────────────┐
                                     │   db:27017         │
                                     │   MongoDB           │
                                     │   (internal only)   │
                                     └──────────────────┘

   All 4 app containers share one Docker Compose network ("myapp_default").
   Only Nginx is reachable from outside the host (ports 80/443).
```

## Request Flow (example: adding a user)

1. Browser sends `POST https://myapp.local/api/users` with `{"name": "..."}`.
2. Nginx terminates TLS, adds `X-Forwarded-*` headers, proxies to `http://127.0.0.1:3001/users`.
3. The `api` container (Express) validates the body and inserts a document via the
   MongoDB driver into `db` over the internal Docker network.
4. `db` (MongoDB) persists the document to the `mongodb-data` named volume.
5. `api` responds `201 Created` with the new user; Nginx relays it back to the browser.
6. The React app (`web`) re-fetches `/api/users` and re-renders the list.

## Deployment Flow (Ansible)

```
02_ansible_setup/server_setup.yml   → update, base packages, UFW, Docker, Nginx installed
                ↓
08_ansible_automation/deploy_app.yml → copy source + .env to /opt/myapp, docker compose build/up
                ↓
08_ansible_automation/deploy_nginx.yml → generate self-signed cert, template nginx config,
                                          enable site, disable default, reload nginx
                ↓
        site.yml (import_playbook) runs all three, in order, with one command
```
