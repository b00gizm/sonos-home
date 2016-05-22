#!/usr/bin/env bash

sed -i "s/%SONOS_HTTP_API_HOST%/${SONOS_HTTP_API_SERVICE_HOST}/" /etc/nginx/conf.d/default.conf
sed -i "s/%SONOS_HTTP_API_PORT%/${SONOS_HTTP_API_SERVICE_PORT}/" /etc/nginx/conf.d/default.conf

cat /etc/nginx/conf.d/default.conf

nginx -g "daemon off;"

