FROM nginx:alpine

COPY . /usr/share/nginx/html
COPY infra/nginx.conf /etc/nginx/conf.d/default.conf
COPY infra/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
