# Deployment Guide

Step-by-step instructions to deploy this project from scratch on a fresh Ubuntu host.

## 1. Clone and configure

```bash
git clone https://github.com/aliSadrSharif/ansibleLab.git
cd ansibleLab
cp .env.example .env
# edit .env with real MongoDB / Mongo Express credentials
```

Expected: a `.env` file with `MONGO_ROOT_USER`, `MONGO_ROOT_PASSWORD`,
`MONGO_EXPRESS_USER`, `MONGO_EXPRESS_PASSWORD` set.

## 2. Install Ansible collections (control node)

```bash
ansible-galaxy collection install community.docker community.crypto community.general
```

## 3. Run the full automation

```bash
cd 08_ansible_automation
ansible-playbook -i ../02_ansible_setup/inventory site.yml
```

Expected output: `PLAY RECAP` with `failed=0` across all three plays (server prep, app
deploy, nginx/SSL). Example from an actual run:

```
target                     : ok=40   changed=3    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
```

## 4. Verify

```bash
sudo docker compose -f /opt/myapp/docker-compose.yaml ps
curl -sk https://myapp.local/            # expect HTTP 200
curl -sk https://myapp.local/api/users   # expect a JSON array
curl -sI http://myapp.local/             # expect 301 -> https://myapp.local/
```

If `myapp.local` doesn't resolve on your client machine, add
`127.0.0.1 myapp.local` (or the server's real IP) to your local `/etc/hosts`.

## 5. Day-2 operations

- **Redeploy after a code change**: re-run
  `ansible-playbook -i ../02_ansible_setup/inventory deploy_app.yml` — it re-copies
  source and rebuilds only what changed.
- **Rotate the SSL cert**: delete `/etc/nginx/ssl/myapp.local.crt` on the target and
  re-run `deploy_nginx.yml`.
- **View logs**: `sudo docker compose -f /opt/myapp/docker-compose.yaml logs -f <service>`.
