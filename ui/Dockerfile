FROM nginx
COPY build /var/www/cobudget
COPY nginx/nginx-conf-template /etc/nginx/conf.d
CMD /bin/bash -c "envsubst '\$DOMAIN' < /etc/nginx/conf.d/nginx-conf-template >/etc/nginx/nginx.conf && nginx -g 'daemon off;'"