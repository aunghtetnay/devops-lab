
FROM node:10-alpine

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY sample-nodejs/package.json ./

USER node

RUN npm install

COPY --chown=node:node sample-nodejs/index.js .

EXPOSE 8080

CMD [ "node", "index.js" ]
