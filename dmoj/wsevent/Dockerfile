FROM node:22-slim

WORKDIR /home

RUN npm install qu ws simplesets

# code
COPY repo/websocket /home/code/websocket

# config
COPY wsevent/config.js /home/code/websocket

EXPOSE 15100
EXPOSE 15101
EXPOSE 15102

CMD node /home/code/websocket/daemon.js
