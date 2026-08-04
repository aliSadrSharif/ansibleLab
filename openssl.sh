#!/bin/bash

# Generate a new private key
openssl genrsa -out private.key 2048

# Generate a new CSR
openssl req -new -key private.key -out csr.csr

# Generate a new certificate
openssl x509 -req -days 365 -in csr.csr -signkey private.key -out certificate.crt
