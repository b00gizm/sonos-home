#!/usr/bin/env bash

sed -i "s/%SONOS_HTTP_API_HOST%/${SONOS_HTTP_API_SERVICE_HOST}/" /etc/nginx/conf.d/default.conf
sed -i "s/%SONOS_HTTP_API_PORT%/${SONOS_HTTP_API_SERVICE_PORT}/" /etc/nginx/conf.d/default.conf

cp /etc/http-basic/api-user /etc/nginx/.htpasswd
chown root:www-data /etc/nginx/.htpasswd
chmod 640 /etc/nginx/.htpasswd

nginx -g "daemon off;"

