FROM node:8

WORKDIR /app
COPY package*.json /app/
RUN npm i && \
    cd /app/node_modules && \
    ln -s ../app ./

ARG NODE_ENV
ENV APP_ENV development
EXPOSE 9000
VOLUME [ "/app/node_modules" ]

CMD npm start
