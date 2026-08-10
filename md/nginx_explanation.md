# Nginx Configuration Explanation

Host Nginx is the only public entry point. Configuration is rendered from `ansible/roles/proxy/templates/nginx.conf.j2` to `/etc/nginx/sites-available/myapp.local` and enabled via symlink in `sites-enabled/`. The default site is removed.

## Upstreams

| Upstream | Targets | Notes |
|----------|---------|-------|
| `web_backend` | `127.0.0.1:3000` | React SPA |
| `api_backend` | `127.0.0.1:3001-3003` | `least_conn` across three API replicas |
| `mongo_express_backend` | `127.0.0.1:8081` | Admin UI |

Host Nginx cannot resolve Compose service names (`web`, `api-1`, …), so upstreams use loopback addresses that match the Compose port publishes.

## HTTP server (`:80`)

When `tls_enabled` is true (default), every request returns `301` to `https://$host$request_uri`.

## HTTPS server (`:443`)

- Loads `/etc/nginx/ssl/myapp.local.crt` and `.key`
- Protocols: TLSv1.2 / TLSv1.3
- Strong ciphers; server cipher preference on
- Proxy headers: `Host`, `X-Real-IP`, `X-Forwarded-For`, `X-Forwarded-Proto`
- Locations:
  - `/` → `web_backend`
  - `/api/` → `api_backend/` (trailing slash strips `/api` prefix for Express routes like `/users`)
  - `/mongo/` → `mongo_express_backend`
- Basic `502/503/504` error page

## Why host Nginx (not Compose Nginx)

Assignment stages 2.3 and 6.3 require apt-installed Nginx, `sites-available` / `sites-enabled`, `nginx -t`, and `systemctl reload`. Running Nginx only in Compose would conflict with those requirements and with UFW on ports 80/443.
