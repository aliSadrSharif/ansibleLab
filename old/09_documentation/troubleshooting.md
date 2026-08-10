# Troubleshooting Guide

## Docker build fails

**Symptom**: `docker compose build` or Ansible's "Build Docker images" task errors out.

**Cause**: usually a missing/renamed dependency, a bad base image tag, or a Dockerfile
syntax error.

**Fix**:
1. Check the logs: `docker compose build --no-cache <service> 2>&1 | tee build.log`.
2. Validate Dockerfile syntax: `docker build --check frontend` / `backend`.
3. Confirm dependencies exist: `npm install` locally in `frontend/`/`backend/` first.
4. Confirm the base image tag is real: `docker pull node:24-alpine3.22`.

## Ansible connection / become fails

**Symptom**: `ansible-playbook` reports `UNREACHABLE` or every task fails on privilege
escalation ("a password is required").

**Cause**: for this local-connection setup, it means `sudo` needs a password and Ansible
has no way to supply one interactively.

**Fix**:
1. Test the connection directly: `ansible webservers -i 02_ansible_setup/inventory -m ping`.
2. Check the inventory: confirm `ansible_connection=local` and
   `ansible_python_interpreter=/usr/bin/python3` are set.
3. Check permissions: the invoking user must be in the `sudo` group.
4. Verify the Python interpreter exists: `/usr/bin/python3 --version`.
5. If `become` fails with a password prompt, either run `ansible-playbook --ask-become-pass`
   interactively, or grant the invoking user a scoped `NOPASSWD` sudoers rule for
   automation (what this project did — see `02_ansible_setup/server_setup.yml` comments).

## Nginx 502 Bad Gateway

**Symptom**: browsing to the domain returns `502 Bad Gateway`.

**Cause**: the upstream container (web/api/mongo-express) is down, unhealthy, or the port
mapping doesn't match the Nginx `proxy_pass` target.

**Fix**:
1. Check container status: `docker compose ps` — every service should say `healthy`/`Up`.
2. Verify port mapping: `docker compose ps` output must show `127.0.0.1:PORT->PORT/tcp`
   for the exact ports referenced in the Nginx config.
3. Check the proxy config: `sudo nginx -T | grep -A5 'location /'`.
4. Check logs: `sudo tail -f /var/log/nginx/myapp.local.error.log` and
   `docker compose logs <service>`.

## SSL certificate errors

**Symptom**: browser/curl reports certificate errors, or Nginx fails to start after
enabling HTTPS.

**Cause**: wrong certificate path, bad permissions, or an invalid/self-signed cert being
rejected by a strict client (expected for self-signed — use `curl -k` for testing).

**Fix**:
1. Verify the certificate path matches `ssl_certificate`/`ssl_certificate_key` in the
   Nginx config exactly.
2. Check permissions: private key should be `600` and owned by root
   (`ls -l /etc/nginx/ssl/`).
3. Check certificate validity: `openssl x509 -in /etc/nginx/ssl/myapp.local.crt -noout
   -dates`.
4. Test the Nginx configuration: `sudo nginx -t` before reloading.
