FROM node:22-slim

WORKDIR /home/node

RUN npm install mathoid@0.7.6

COPY config.yaml /home/node/node_modules/mathoid/

EXPOSE 10044

WORKDIR /home/node/node_modules/mathoid

CMD node /home/node/node_modules/mathoid/server.js
