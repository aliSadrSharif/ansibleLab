# Troubleshooting

## Ansible cannot become root

**Symptom:** `Missing sudo password` / privilege escalation failure.

**Cause:** Target user needs a sudo password.

**Fix:** Run with `--ask-become-pass` or `--become-password-file /path/to/file`.

## apt update fails with `file:/cdrom`

**Symptom:** `E: The repository 'file:/cdrom jammy Release' no longer has a Release file`.

**Cause:** Ubuntu install left a CDROM source in `/etc/apt/sources.list`.

**Fix:** The `common` role comments lines matching `cdrom:` / `file:/+cdrom`. Re-run `server_setup.yml`.

## Docker build OOM / killed on the VM

**Symptom:** frontend build exits with signal 9 / “Killed”.

**Cause:** 2 GB RAM + React build.

**Fix:** Dockerfile sets `NODE_OPTIONS=--max-old-space-size=1536`. Ensure swap is enabled (`swapon --show`). Fallback: build on the controller and `docker save | docker load` onto the VM.

## Nginx 502 Bad Gateway

**Checks:**

```bash
sudo docker compose -f /opt/myapp/docker-compose.yml ps
curl -sI http://127.0.0.1:3000/
curl -s http://127.0.0.1:3001/users
sudo nginx -t
sudo tail -50 /var/log/nginx/myapp.local.error.log
```

**Common causes:** containers not healthy; wrong upstream ports; Nginx reloaded before Compose finished.

## SSL browser warning / NET::ERR_CERT_AUTHORITY_INVALID

**Expected** for self-signed certs. Use `curl -k` or trust the cert manually. Confirm SAN includes `DNS:myapp.local`:

```bash
sudo openssl x509 -in /etc/nginx/ssl/myapp.local.crt -noout -ext subjectAltName
```

## Containers reachable from LAN despite UFW

**Cause:** Docker publishes into the `DOCKER` iptables chain and bypasses UFW.

**Fix:** Publish only on loopback (`127.0.0.1:PORT:PORT`) — already configured in `docker-compose.yml`.

## mongo-express connects without auth / empty DB list

**Cause:** Setting `ME_CONFIG_MONGODB_SERVER` makes mongo-express ignore `ME_CONFIG_MONGODB_URL`.

**Fix:** Keep `ME_CONFIG_MONGODB_SERVER` unset; use `ME_CONFIG_MONGODB_URL` only.

## API CORS errors in the browser

**Cause:** Calling the API from a different origin than Nginx.

**Fix:** Use same-origin `/api` (default `REACT_APP_API_URL=/api`). Optional allowlist via `CORS_ORIGINS` in `.env`.

## Ansible synchronize / rsync permission errors

**Fix:** The `app` role runs `synchronize` with `become: false` as the SSH user, then fixes ownership on `/opt/myapp`.
