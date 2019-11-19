FROM node:alpine

WORKDIR /usr/app

COPY package.json ./
COPY ./yarn.lock ./
RUN yarn install | tee /var/log/visit-counter-install.log
COPY ./ ./

CMD ["yarn", "start"]