#!/bin/bash

# Update the system
sudo apt update
sudo apt upgrade -y

# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Run Certbot
sudo certbot --nginx -d $1

# Renew the certificate
sudo certbot renew --dry-run --verbose