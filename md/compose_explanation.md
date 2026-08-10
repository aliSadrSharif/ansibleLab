# docker-compose.yml Explanation

Single Compose file: `docker-compose.yml`. Host Nginx owns ports 80/443, so Compose no longer includes an `nginx` service.

## Services

| Service | Role |
|---------|------|
| `web` | React production build served on `127.0.0.1:3000` |
| `api-1` / `api-2` / `api-3` | Three identical Express API replicas (YAML anchor `x-api-common`) |
| `db` | MongoDB 4.4 with named volume `mongodb-data` |
| `mongo-express` | DB admin UI on `127.0.0.1:8081`, base path `/mongo/` |

## Design choices

1. **Loopback binds** (`127.0.0.1:PORT:PORT`) — Docker publishes into the `DOCKER` iptables chain and bypasses UFW. Binding to loopback keeps containers unreachable from the LAN; only host Nginx is public.
2. **YAML anchor `x-api-common`** — shared build, env, healthcheck, and `depends_on` for the three API replicas.
3. **Health checks** — every service has a healthcheck; APIs wait for `db` `service_healthy`.
4. **`ME_CONFIG_MONGODB_URL`** — mongo-express authenticates correctly; `ME_CONFIG_MONGODB_SERVER` must stay unset or credentials are discarded.
5. **Pinned mongo-express image** — `mongo-express:1.0.2-20-alpine3.19` for reproducible deploys.
6. **Explicit `appnet` bridge network** — service DNS names resolve within the Compose network.
7. **Named volume `mongodb-data`** — database persistence across restarts.
8. **`restart: unless-stopped`** — containers come back after reboot.
9. **Secrets via `.env`** — `MONGO_ROOT_*` and `MONGO_EXPRESS_*` injected from a gitignored `.env` templated by Ansible.

## Port map (host)

```
127.0.0.1:3000 -> web:3000
127.0.0.1:3001 -> api-1:3001
127.0.0.1:3002 -> api-2:3001
127.0.0.1:3003 -> api-3:3001
127.0.0.1:8081 -> mongo-express:8081
(db:27017 internal only)
```
