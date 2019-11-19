FROM node:alpine

WORKDIR /usr/app
COPY ./package.json ./
COPY ./yarn.lock ./
# to have log output like these around see https://stackoverflow.com/questions/37832575/how-to-view-logs-for-a-docker-image
RUN yarn install | tee /var/log/node-webapp-install.log
COPY . .

CMD ["yarn", "start"]