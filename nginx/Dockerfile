FROM nginx:stable-alpine

ENV NGINX_DIR=/etc/nginx

RUN apk update --no-cache && \
    apk upgrade --no-cache

COPY setup/nginx.conf ${NGINX_DIR}/nginx.conf
COPY setup/index.html /usr/share/nginx/html/index.html
COPY setup/default.conf ${NGINX_DIR}/conf.d/

# Copy SSL certificates
RUN mkdir -p ${NGINX_DIR}/certs
#COPY setup/ckan-ssl.crt ${NGINX_DIR}/certs/
#COPY setup/ckan-ssl.key ${NGINX_DIR}/certs/

ENTRYPOINT \
  nginx -g 'daemon off;'
