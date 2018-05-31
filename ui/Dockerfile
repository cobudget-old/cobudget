FROM node:6 as builder
RUN mkdir /src
WORKDIR /src
COPY . /src
RUN npm install bower
RUN echo '{ "allow_root": true }' > /root/.bowerrc
RUN npm install -g gulp
RUN npm install
RUN npm rebuild node-sass
ARG NODE_ENV
RUN gulp build

FROM nginx
COPY --from=builder /src/build /var/www/cobudget
COPY nginx/nginx-conf-template /etc/nginx/conf.d
CMD /bin/bash -c "envsubst '\$DOMAIN' < /etc/nginx/conf.d/nginx-conf-template >/etc/nginx/nginx.conf && nginx -g 'daemon off;'"