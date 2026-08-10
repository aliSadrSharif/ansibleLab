#!/usr/bin/env bash
# Collect controller-side assignment evidence into ../results/
# Run from the ansible/ directory after a successful site.yml run.
#
# Usage:
#   cd ansible
#   ./../scripts/collect_evidence.sh [become_password]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ANSIBLE_DIR="$REPO_ROOT/ansible"
RESULTS="$REPO_ROOT/results"
DOMAIN="${DOMAIN:-myapp.local}"
SERVER_IP="${SERVER_IP:-192.168.31.104}"
BECOME_PASS="${1:-${ANSIBLE_BECOME_PASS:-}}"

mkdir -p "$RESULTS"
cd "$ANSIBLE_DIR"

EXTRA_VARS=()
if [[ -n "$BECOME_PASS" ]]; then
  EXTRA_VARS+=(-e "ansible_become_pass=${BECOME_PASS}")
fi

echo "==> Copying inventory"
cp -f inventory.ini "$RESULTS/inventory"

echo "==> ansible ping"
ansible webservers -m ping "${EXTRA_VARS[@]}" | tee "$RESULTS/ping_test.txt"

echo "==> ansible setup (facts)"
ansible webservers -m setup "${EXTRA_VARS[@]}" | tee "$RESULTS/facts.txt"

echo "==> Project structure"
{
  echo "=== Repository tree (excluding node_modules/.git) ==="
  (cd "$REPO_ROOT" && find . -path './.git' -prune -o -path '*/node_modules/*' -prune -o -print | sort)
} | tee "$RESULTS/project_structure.txt"

echo "==> Final structure"
{
  echo "=== Final project structure ==="
  (cd "$REPO_ROOT" && find . -path './.git' -prune -o -path '*/node_modules/*' -prune -o -print | sort)
} | tee "$RESULTS/final_structure.txt"

echo "==> Git history"
(cd "$REPO_ROOT" && git log --oneline --graph --all | head -100) | tee "$RESULTS/git_history.txt"

echo "==> Local hosts file excerpt"
{
  echo "=== /etc/hosts (relevant lines) ==="
  grep -E "myapp\.local|${SERVER_IP}" /etc/hosts 2>/dev/null || echo "(no myapp.local entry yet)"
  echo
  echo "Expected entry:"
  echo "${SERVER_IP} ${DOMAIN}"
} | tee "$RESULTS/hosts_file.txt"

echo "==> Client-side HTTP/HTTPS tests against ${DOMAIN}"
{
  echo "=== curl -I http://${DOMAIN}/ ==="
  curl -sI --connect-timeout 5 "http://${DOMAIN}/" || true
  echo
  echo "=== curl -kI https://${DOMAIN}/ ==="
  curl -skI --connect-timeout 5 "https://${DOMAIN}/" || true
  echo
  echo "=== curl -kL https://${DOMAIN}/ (body head) ==="
  curl -skL --connect-timeout 5 "https://${DOMAIN}/" | head -c 500 || true
  echo
  echo
  echo "=== curl -k https://${DOMAIN}/api/users ==="
  curl -sk --connect-timeout 5 "https://${DOMAIN}/api/users" || true
  echo
  echo
  echo "=== curl -kI https://${DOMAIN}/mongo/ (expect 401) ==="
  curl -skI --connect-timeout 5 "https://${DOMAIN}/mongo/" || true
  echo
} | tee "$RESULTS/06_test_results.txt"

cp -f "$RESULTS/06_test_results.txt" "$RESULTS/07_test_results.txt"

{
  echo "=== Stage 4 local / server build evidence ==="
  echo "Application was built on the server via Ansible community.docker.docker_compose_v2."
  echo "See 04_container_status.txt and deploy_log.txt / 08_playbook_output.txt for build output."
  echo
  echo "=== Direct loopback checks via SSH ==="
  ssh -o BatchMode=yes vm1 "curl -s http://127.0.0.1:3000/ | head -c 200; echo; curl -s http://127.0.0.1:3001/users; echo"
} | tee "$RESULTS/04_test_results.txt"

echo "==> Done. Artifacts written under $RESULTS"
ls -la "$RESULTS"
