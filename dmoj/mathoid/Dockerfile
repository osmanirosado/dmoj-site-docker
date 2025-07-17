FROM node:22

WORKDIR /home/node

RUN npm install mathoid@0.7.6

EXPOSE 10044

WORKDIR /home/node/node_modules/mathoid
CMD /home/node/node_modules/mathoid/server.js
