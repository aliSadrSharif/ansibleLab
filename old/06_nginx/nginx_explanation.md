# Nginx Configuration Explanation

## Design

| Decision | Value |
|---|---|
| Domain name | `myapp.local` (as suggested by the assignment) |
| Application port | `web` on 3000, `api` on 3001, `mongo-express` on 8081 (all loopback-only) |
| Proxy pattern | Reverse proxy — Nginx is the only public listener; every backend is bound to `127.0.0.1` |
| Headers forwarded | `Host`, `X-Real-IP`, `X-Forwarded-For`, `X-Forwarded-Proto` |

## Routing

- `location /` → `http://127.0.0.1:3000` (React frontend)
- `location /api/` → `http://127.0.0.1:3001/` (Express API; trailing slash on `proxy_pass`
  strips the `/api` prefix before forwarding, so the backend still sees `/users`, not
  `/api/users`)
- `location /mongo/` → `http://127.0.0.1:8081` (Mongo Express, matching its
  `ME_CONFIG_SITE_BASEURL=/mongo/` setting in `docker-compose.yaml`)

## Why these headers

- `Host` — lets the upstream app see the original domain the client requested, not
  `127.0.0.1`.
- `X-Real-IP` / `X-Forwarded-For` — preserve the real client IP, since without them the
  backend would only see Nginx's own address for every request.
- `X-Forwarded-Proto` — tells the backend whether the original request was `http` or
  `https`, important once TLS termination happens at Nginx (see `07_ssl/`).

## Error handling

`error_page 502 503 504 /50x.html;` serves a static error page whenever an upstream
container is down or unhealthy, instead of leaking a raw connection-refused error to
clients.

## Activation steps performed

1. Config placed at `/etc/nginx/sites-available/myapp.local`.
2. Symlinked into `/etc/nginx/sites-enabled/myapp.local` (`ln -s`).
3. Default site (`/etc/nginx/sites-enabled/default`) removed so it can't intercept
   requests.
4. `nginx -t` — syntax OK.
5. `systemctl reload nginx` — applied without dropping active connections.
6. `/etc/hosts` updated with `127.0.0.1 myapp.local` so the domain resolves locally
   (see `06_nginx/hosts_file.txt`).
