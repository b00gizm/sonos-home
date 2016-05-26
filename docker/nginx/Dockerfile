FROM resin/rpi-raspbian:jessie
MAINTAINER Pascal Cremer "b00gizm@gmail.com"

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
        nginx \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Nginx configs
COPY rootfs/etc/nginx/nginx.conf          /etc/nginx/nginx.conf
COPY rootfs/etc/nginx/ssl/                /etc/nginx/ssl/
COPY rootfs/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Nginx start script
COPY start-nginx.sh /usr/bin/start-nginx

RUN chmod +x /usr/bin/start-nginx \
    && mkdir -p /etc/nginx/logs \
    && mkdir /usr/share/nginx/logs \
    && ln -sf /dev/stdout /etc/nginx/logs/access.log \
    && ln -sf /dev/stdout /etc/nginx/logs/error.log

EXPOSE 80 443

CMD ["/usr/bin/start-nginx"]
