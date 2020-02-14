FROM node:alpine

# download and install a dependency
RUN apk add --update procps

WORKDIR /usr/app

COPY ./package.json ./
COPY ./yarn.lock ./
# to have log output like these around see https://stackoverflow.com/questions/37832575/how-to-view-logs-for-a-docker-image
RUN yarn install | tee /var/log/install.log

# although docker-compose.yml mounts these as volumes, keep these
# as reminder
COPY ./src ./src

CMD ["yarn", "run", "start"]