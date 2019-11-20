FROM node:alpine as builder

# download and install a dependency
RUN apk add --update procps

WORKDIR /usr/app

COPY ./package.json ./
COPY ./yarn.lock ./
# to have log output like these around see https://stackoverflow.com/questions/37832575/how-to-view-logs-for-a-docker-image
RUN yarn install | tee /var/log/frontend-builder.log

# although docker-compose.yml mounts these as volumes, keep these
# as reminder
COPY ./src ./src
COPY ./public ./public

RUN yarn run build  | tee /var/log/frontend-builder.log

###

# is auto started 
FROM nginx

COPY --from=builder /usr/app/build /usr/share/nginx/html
