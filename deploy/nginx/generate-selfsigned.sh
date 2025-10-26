#!/bin/sh
# Simple self-signed certificate generator for dev
set -e
mkdir -p "$(dirname "$0")/certs"
OUT_DIR="$(pwd)/deploy/nginx/certs"
mkdir -p "$OUT_DIR"
if [ -f "$OUT_DIR/fullchain.pem" ] && [ -f "$OUT_DIR/privkey.pem" ]; then
  echo "Self-signed cert already exists: $OUT_DIR"
  exit 0
fi

echo "Generating self-signed certificate into $OUT_DIR"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$OUT_DIR/privkey.pem" -out "$OUT_DIR/fullchain.pem" \
  -subj "/C=US/ST=State/L=City/O=Org/OU=Unit/CN=localhost"

echo "Certificate generated"

chmod 644 "$OUT_DIR/fullchain.pem"
chmod 600 "$OUT_DIR/privkey.pem"

exit 0
