FROM node:22-slim

WORKDIR /opt/mathoid

RUN npm install mathoid@0.7.6

COPY config.yaml /opt/mathoid/node_modules/mathoid/

RUN useradd app

USER app

EXPOSE 8888

WORKDIR /opt/mathoid/node_modules/mathoid

CMD node /opt/mathoid/node_modules/mathoid/server.js
