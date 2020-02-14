# Fibonacci Calc

Inside fibonacci-calc-parent do

for production

```sh
docker-compose up --build  --renew-anon-volumes
```

for development

```sh
docker-compose -f docker-compose-dev.yaml up --build  --renew-anon-volumes
```

_As opposed to production, the development mounts the appropriate source folders as volumes into the container._

There are issues if the startup of the images does not happen in some order. If this happens, stop the cluster (CTRL+C) and relaunch above command again :smirk_cat:

Then open
http://localhost:3050/

<img src="./docs/fibonacci-calc-frontend-screenshot.png" alt="Project's Frontend Screenshot"
	title="Project's Frontend Screenshot" width="1000" height="auto" />

## Project's Environment Concept

<img src="./docs/fibonacci-calc-devenv-concept.png" alt="Project's Dev Environment Concept"
	title="Project's Dev Environment Concept Screenshot" width="1000" height="auto" />

## Project's Flow Concept

<img src="./docs/fibonacci-calc-flow-concept.png" alt="Project's Flow Concept"
	title="Project's Flow Concept Screenshot" width="700" height="auto" />

## Project's CI/CD Concept

TBD Pic Project's CI/CD Concept Screenshot

## Build Commands

### For Production

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/prod/frontend -f fibonacci-calc-frontend/Dockerfile fibonacci-calc-frontend/
```

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/prod/server -f fibonacci-calc-server/Dockerfile fibonacci-calc-server/
```

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/prod/worker -f fibonacci-calc-worker/Dockerfile fibonacci-calc-worker/
```

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/prod/proxy -f fibonacci-calc-proxy/Dockerfile fibonacci-calc-proxy/
```

### For Development

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/dev/frontend -f fibonacci-calc-frontend/Dockerfile.dev fibonacci-calc-frontend/
```

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/dev/server -f fibonacci-calc-server/Dockerfile.dev fibonacci-calc-server/
```

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/dev/worker -f fibonacci-calc-worker/Dockerfile.dev fibonacci-calc-worker/
```

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/dev/proxy -f fibonacci-calc-proxy/Dockerfile fibonacci-calc-proxy/
```

## Issue Parade

### Uncaught Error: Incompatible SockJS! Main site uses: "1.4.0", the iframe: "1.3.0".

See https://github.com/facebook/create-react-app/issues/7782 for nginx changes, but error persists. Further https://github.com/facebook/create-react-app/pull/7988 should close this up.

## DNK

### Default Port Of React Dev Server

See https://create-react-app.dev/docs/advanced-configuration/

> The default port used by Express is 3000, the same default port used by ReactJS development server.

### Docker logs not showing colors

See https://stackoverflow.com/a/38508869/3274229

> Not quite the answer to this specific problem, but if you're using the debug library and have the same issue there is a non-documented environment variable that enables the colors even when in a non TTY:
> https://github.com/visionmedia/debug/blob/39ecd87bcc145de5ca1cbea1bf4caed02c34d30a/node.js#L45
>
> So adding DEBUG_COLORS=true to your environment variables fixes it for the debug library colors.

```json
"scripts": {
    "start": "DEBUG_COLORS=true DEBUG=* node src/index.js",
    ...
},
```

### NPM debug - Use Log Message Parameter Substitution Formatters

See

- https://www.npmjs.com/package/debug#formatters
- https://nodejs.org/api/util.html#util_util_format_format_args

### Install Pgadmin4

See https://wiki.postgresql.org/wiki/Apt

```sh
sudo apt-get install curl ca-certificates gnupg
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt-get update
sudo apt-get install pgadmin4
```

### How To Reset Anonymus Volumes On Compose Up

Docker knows three kinds of volumes(explained in https://github.com/docker/compose/issues/2127#issuecomment-255012324). For anonymous volumes https://github.com/docker/compose/issues/2127#issuecomment-254987670 explains it's usage for a MySQL image.

Later on https://github.com/docker/compose/issues/2127#issuecomment-428392434 uncovers the presence of the option for recreateing anonymous volumes.

https://docs.docker.com/compose/reference/up/

```
    -V, --renew-anon-volumes   Recreate anonymous volumes instead of retrieving
                               data from the previous containers
```
