#!/usr/bin/env bash
SUBJ="/C=US/ST=NY/L=NYC/O=WEB/OU=APEX/CN=cas-demo.org"
KEY_OUT="ssl/cas-demo.key"
DER_OUT="cas/ssl/cas-demo.der"
CRT_OUT="ssl/cas-demo.crt"
ALIAS="cas-demo"
STOREPASS="changeit"
KEYSTORE="${JAVA_HOME}/jre/lib/security/cacerts"

if [[ -n "${1}" && "${1}" = "--delete" ]]; then
    sudo keytool -delete -alias "${ALIAS}" -keystore "${KEYSTORE}" -storepass "${STOREPASS}"
    rm -rf ssl
    rm -rf cas/ssl
else
    mkdir ssl
    mkdir cas/ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "${KEY_OUT}" -out "${CRT_OUT}" -subj "${SUBJ}"
    openssl x509 -in "${CRT_OUT}" -out "${DER_OUT}" -outform DER
    sudo keytool -import -keystore "${KEYSTORE}" -file "${DER_OUT}" -alias "${ALIAS}" -storepass "${STOREPASS}"
fi
