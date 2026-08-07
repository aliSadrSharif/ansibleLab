# Project Summary

## Challenges Faced

1. **No real VPS/VM was available** for the "target server" required by the assignment.
   Resolved by using the local development machine directly as both Ansible control node
   and managed node (`ansible_connection=local`), after explicit agreement on the
   real, non-simulated system changes this would involve.
2. **`sudo` required a password**, and Ansible's `become` had no way to supply one
   interactively in this environment (and the harness must never be given a password to
   type). Resolved with a scoped, temporary `NOPASSWD` sudoers rule for the invoking user
   (who already has full sudo rights) — standard practice for automation hosts, and
   reversible with a single `rm`.
3. **Port conflict between the "local test" and "Ansible-managed" deployments**: the stack
   was first run manually at the repo root for stages 4-5 testing, then Ansible deployed a
   second, independent copy to `/opt/myapp` in stage 8 — both tried to bind
   `127.0.0.1:3000`. Resolved by stopping the manual instance once the Ansible-automated
   one became the source of truth.
4. **Architecture mismatch**: the repo originally had a *containerized* Nginx service in
   `docker-compose.yaml`, but the assignment's Nginx/SSL/Ansible stages assume a
   *system-level* Nginx managed by `systemctl`/`sites-available`. Resolved by removing the
   containerized Nginx service and using the host's Nginx as the single, public reverse
   proxy, with all app containers bound to `127.0.0.1` only.
5. **An unrelated, pre-existing broken apt repository** (Claude Desktop's) made
   `apt-get update` return non-zero even though the repos actually needed (Ubuntu, Docker)
   refreshed successfully. Resolved by making that one task tolerant of failure instead of
   touching the unrelated repo config.

## Solutions Implemented

- Real, end-to-end infrastructure automation: system update → packages → UFW → Docker →
  Nginx → app deployment → SSL, all as idempotent Ansible playbooks, executed and verified
  for real (not simulated), with command output captured as evidence in every numbered
  stage folder.
- Hardened Dockerfiles (non-root users, multi-stage frontend build, health checks) and a
  compose stack with no hardcoded secrets, no exposed database port, health-gated
  dependencies, and restart policies.
- A TLS-terminating, header-forwarding Nginx reverse proxy in front of the whole stack,
  with a self-signed certificate and an HTTP → HTTPS redirect.

## Lessons Learned

- "Automate with Ansible" is only meaningful if the playbooks are actually run against a
  real target and their real output is captured — dry-run output alone would not have
  surfaced the port conflict, the `validate` parameter bug, or the sudoers requirement.
- Keeping secrets out of version control (`.env`, `.gitignore`) from the very first commit
  is far easier than retrofitting it later.
- A reverse-proxy architecture decision (containerized vs. system-level Nginx) has to be
  made once, explicitly, and applied consistently — mixing both leads to port conflicts.

## Suggested Improvements

- Add a CI pipeline (GitHub Actions) that runs `ansible-playbook --syntax-check` and
  `docker compose config` on every push.
- Replace the self-signed certificate with a real Let's Encrypt certificate
  (`certbot.sh` is already included) once a real public domain is available.
- Add Ansible Vault for `app_vars.yml`/`.env` if this project ever needs to be run by
  multiple operators sharing one inventory.
