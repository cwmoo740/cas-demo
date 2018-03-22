#!/usr/bin/env bash
mkdir -p nginx/ssl
SUBJ="/C=US/ST=NY/L=NYC/O=WEB/OU=APEX/CN=localhost"
KEYOUT="nginx/ssl/localhost.key"
OUT="nginx/ssl/localhost.crt"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "${KEYOUT}" -out "${OUT}" -subj "${SUBJ}"
