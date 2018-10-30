#!/usr/bin/env bash
openssl req \
  -new \
  -newkey rsa:4096 \
  -days 3650 \
  -nodes \
  -x509 \
  -subj "/C=US/ST=CA/L=SF/O=demo/CN=demowebapp" \
  -keyout swa_opp_demo.key \
  -out swa_opp_demo.cert

docker-compose build --no-cache
