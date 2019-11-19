# use an existing docker image as base
FROM alpine

# download and install a dependency
RUN apk add --update redis
RUN apk add --update gcc

# tell the imahe what to do when it starts
CMD ["redis-server"]
