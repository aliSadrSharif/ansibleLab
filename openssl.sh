#!/bin/bash

set -e

DOMAIN="${1:-myapp.local}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSL_DIR="$SCRIPT_DIR/nginx/ssl"

mkdir -p "$SSL_DIR"

SAN="${2:-DNS:$DOMAIN,DNS:localhost,IP:127.0.0.3,IP:127.0.0.1}"

# Browsers ignore CN and require subjectAltName, so a cert without it is rejected outright.
openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout "$SSL_DIR/$DOMAIN.key" \
    -out "$SSL_DIR/$DOMAIN.crt" \
    -subj "/C=DE/ST=Saxony/L=Dresden/O=DaneshkarTeamProject/OU=DevOps/CN=$DOMAIN" \
    -addext "subjectAltName=$SAN" \
    -addext "basicConstraints=critical,CA:FALSE" \
    -addext "keyUsage=critical,digitalSignature,keyEncipherment" \
    -addext "extendedKeyUsage=serverAuth"

echo "Certificate created:"
echo "  $SSL_DIR/$DOMAIN.crt"
echo "  $SSL_DIR/$DOMAIN.key"