FROM node:22-slim

WORKDIR /home

RUN npm install qu ws simplesets

COPY repo/websocket /home/code/websocket

EXPOSE 15100
EXPOSE 15101
EXPOSE 15102

CMD node /home/code/websocket/daemon.js
