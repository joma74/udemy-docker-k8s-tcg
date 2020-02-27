# Fibonacci Calc

## K8s Usage

TBD

## Docker Compose Usage

Inside fibonacci-calc-parent do

for production

```sh
docker-compose up --build --renew-anon-volumes
```

for development

```sh
docker-compose -f docker-compose-dev.yaml up --build --renew-anon-volumes
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

## Project's K8s Concept

<img src="./docs/fibonacci-calc-k8s-concept.png" alt="Project's K8s Concept"
	title="Project's K8s Concept Screenshot" width="700" height="auto" />

## Project's CI/CD Concept

TBD Pic Project's CI/CD Concept Screenshot

## K8s Build Commands

### For Production

```sh
docker pull redis:latest
docker image tag redis:latest joma74/udemy-docker-k8s-tcg/fibonacci-calc/redis/prod
```

```sh
docker pull postgres:latest
docker image tag postgres:latest joma74/udemy-docker-k8s-tcg/fibonacci-calc/postgres/prod
```

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/frontend/prod -f fibonacci-calc-frontend/Dockerfile fibonacci-calc-frontend/
```

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/server/prod -f fibonacci-calc-server/Dockerfile fibonacci-calc-server/
```

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/worker/prod -f fibonacci-calc-worker/Dockerfile fibonacci-calc-worker/
```

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/prox/prod -f fibonacci-calc-proxy/Dockerfile fibonacci-calc-proxy/
```

### For Development

```sh
docker pull redis:latest
docker image tag redis:latest joma74/udemy-docker-k8s-tcg/fibonacci-calc/redis/dev
```

```sh
docker pull postgres:latest
docker image tag postgres:latest joma74/udemy-docker-k8s-tcg/fibonacci-calc/postgres/dev
```

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/frontend/dev -f fibonacci-calc-frontend/Dockerfile.dev fibonacci-calc-frontend/
```

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/server/dev -f fibonacci-calc-server/Dockerfile.dev fibonacci-calc-server/
```

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/worker/dev -f fibonacci-calc-worker/Dockerfile.dev fibonacci-calc-worker/
```

```sh
docker build -t joma74/udemy-docker-k8s-tcg/fibonacci-calc/proxy/dev -f fibonacci-calc-proxy/Dockerfile fibonacci-calc-proxy/
```

## Update A K8s Deployment With New Images For Development

To update a deployment with new images to K8s is unneccessary hard. One must first be aware that the docker image cache against one builds on standard dev/user login is - at least when virtualized - NOT the same as the docker image cache on the virtualized host where K8s runs.

For that executing `eval $(minikube docker-env)` changes the appropriate environment variables in one's shell. So, after doing that, a `docker build -t ...` command will put the image inside of that cache where K8s on the virtualized host can access them.

Second step is to inform K8s that changes - in this case the undelying image - for deployments should be redeployed. For that one has to kick off a K8s' rollout command.
See

- https://stackoverflow.com/a/57559438
- https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-em-restart-em-

Unfortunately this additionally requires beforehand all deployments' configs to have an `imagePullPolicy: IfNotPresent` or `imagePullPolicy: Never` - to not fail on image pull from whatever external docker registry is set up in the first way.

To sum up the canon is

```sh
eval $(minikube docker-env)
docker build -t ...
kubectl rollout restart deployment server-deployment # targeting an individual deployment
# or
kubectl rollout restart deployment  # targeting all deployments
```

## Check On Status Of Different K8s Objects

```sh
kubectl get deployments
kubectl get pods
kubectl get services
kubectl get secrets
kubectl describe ingress
```

## Ingress Nginx 0.30.0 Installation And Configuration

See https://kubernetes.github.io/ingress-nginx/deploy/#minikube for installation

```sh
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/mandatory.yaml
$ minikube addons enable ingress
```

See https://kubernetes.io/docs/concepts/services-networking/ingress/ for configuration

> !!! attention Starting in Version 0.22.0, ingress definitions using the annotation nginx.ingress.kubernetes.io/rewrite-target are not backwards compatible with previous versions. In Version 0.22.0 and beyond, any substrings within the request URI that need to be passed to the rewritten path must explicitly be defined in a capture group.

See https://github.com/kubernetes/ingress-nginx/blob/master/docs/examples/rewrite/README.md

## Issue Parade

### Uncaught Error: Incompatible SockJS! Main site uses: "1.4.0", the iframe: "1.3.0".

See https://github.com/facebook/create-react-app/issues/7782 for nginx changes, but error persists. Further https://github.com/facebook/create-react-app/pull/7988 should close this up.

### The Stickaround Persistent Volume

Checked pvc was deleted, volumemounted listed nothing, but still this pv sticked around

```sh
$ kubectl describe pv
Name:            pvc-a9e657f3-d591-45c5-8faf-d6aa09cbd6e7
Labels:          <none>
Annotations:     hostPathProvisionerIdentity: 60afeae7-54c4-11ea-a189-080027383d5a
                 pv.kubernetes.io/provisioned-by: k8s.io/minikube-hostpath
Finalizers:      [kubernetes.io/pv-protection]
StorageClass:    standard
==> Status:          Released
Claim:           default/database-persistent-volume-claim
==> Reclaim Policy:  Delete
Access Modes:    RWO
VolumeMode:      Filesystem
Capacity:        1Gi
Node Affinity:   <none>
Message:
Source:
    Type:          HostPath (bare host directory volume)
    Path:          /tmp/hostpath-provisioner/pvc-a9e657f3-d591-45c5-8faf-d6aa09cbd6e7
    HostPathType:
Events:            <none>
```

Seems to be a reported but closed minikube issue named "Deleted hostpath PVs stuck in released state after minikube restart", see https://github.com/kubernetes/minikube/issues/4546. Some logs correlate to what is mentioned there.

```sh
$ minikube ssh
$ cat /tmp/storage-provisioner.INFO
...
I0225 21:57:05.162313       1 controller.go:1073] scheduleOperation[delete-pvc-a9e657f3-d591-45c5-8faf-d6aa09cbd6e7[545a3042-d84b-47c2-a01f-a4badeb509b5]]
I0225 21:57:05.204100       1 controller.go:1040] deletion of volume "pvc-a9e657f3-d591-45c5-8faf-d6aa09cbd6e7" ignored: ignored because identity annotation on PV does not match ours
```

Some other mentioned workaround did not work

```sh
kubectl patch pv -p '{"metadata":{"finalizers":null}}' pvc-a9e657f3-d591-45c5-8faf-d6aa09cbd6e7
```

Finally, this command did remove the pv.

```sh
kubectl delete persistentvolumes pvc-a9e657f3-d591-45c5-8faf-d6aa09cbd6e7
```

## DNK

### How To Get Around The New 0.22.0 Nginx-ingress Rewrite Rule

> Starting in Version 0.22.0, ingress definitions using the annotation nginx.ingress.kubernetes.io/rewrite-target are not backwards compatible with previous versions. In Version 0.22.0 and beyond, **any substrings within the request URI that need to be passed to the rewritten path must explicitly be defined in a capture group**.

See https://github.com/kubernetes/ingress-nginx/blob/master/docs/examples/rewrite/README.md

Wrapped my head around how to apply the root path with this new rule. But then i stumbled upon

> In NGINX, regular expressions follow a first match policy. In order to enable more accurate path matching, ingress-nginx **first orders the paths by descending length** before writing them to the NGINX template as location blocks.

See https://kubernetes.github.io/ingress-nginx/user-guide/ingress-path-matching/

```yml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: nginx-ingres
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  rules:
    - http:
        paths:
          - path: "/(.*)"
            backend:
              serviceName: frontend-cluster-ip-service
              servicePort: 3000
          - path: "/api/(.*)"
            backend:
              serviceName: server-cluster-ip-service
              servicePort: 5000
```

My reasoning is that a path of `/api/(.*)` is longer/more specific and gets the proper rewrite. As opposed to path `/(.*)`, which is shorter/less specific.

### POSTGRES replies on startup with "Error: Database is uninitialized and superuser password is not specified"

One must specify a environment variable of `POSTGRES_PASSWORD` on startup

See https://github.com/docker-library/postgres/issues/456

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

### Connect To Postgresql Database Inside K8s

```sh
$ kubectl exec -it <postgresspod-name> bash
$  PGPASSWORD=<password>
$ psql -h localhost -U postgres postgres
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |

postgres=# \c postgres
You are now connected to database "postgres" as user "postgres".
postgres=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | values | table | postgres
(1 row)

postgres=# select * from values;
 number
--------
     40
     39
     38
     37
(4 rows)
```

### How To Reset Anonymus Volumes On Docker Compose Up

Docker knows three kinds of volumes(explained in https://github.com/docker/compose/issues/2127#issuecomment-255012324). For anonymous volumes https://github.com/docker/compose/issues/2127#issuecomment-254987670 explains it's usage for a MySQL image.

Later on https://github.com/docker/compose/issues/2127#issuecomment-428392434 uncovers the presence of an option for recreateing anonymous volumes.

https://docs.docker.com/compose/reference/up/

```
    -V, --renew-anon-volumes   Recreate anonymous volumes instead of retrieving
                               data from the previous containers
```

### K8s Pods vs Nodes

<img src="./docs/NodeVsPodVs.svg" alt="K8s NodeVsPodVs" style="background-color: Snow;"
	title="Project's K8s Concept Screenshot" width="700" height="auto" />

A Pod can run one or more closely related containers.

Pods run on Nodes.

Each Node is managed by the Master. A Node is a worker machine in Kubernetes and may be a VM or a physical machine.

### K8s Deployments vs Pods vs Services

#### Services

- ClusterIP: Exposes a set of pods to other objects in the cluster
- NodePort: Exposes a set of pods to other objects outside of the cluster

### K8s port vs targetPort vs nodePort vs containerPort

- nodePort: to access service from outside of the cluster [ Service/NodePort ]
- port: to access service from inside of the cluster [ Service/NodePort, Service/ClusterIP ]
- targetPort: where service runs inside [ Service/NodePort, Service/ClusterIP ]
- containerPort: to access service from inside of the cluster [ Deployment/Containers ]

### K8s ReplicaSet or replicas

- creates n replicated Pods, indicated by the replicas field

### Access Kubeadm In Minikube

```sh
$ ll ~/.minikube/cache/v1.17.0/
total 147376
drwxrwxr-x 2 joma joma      4096 Dez 16 00:37 ./
drwxrwxr-x 5 joma joma      4096 Dez 16 00:36 ../
-rwxr-xr-x 1 joma joma  39342080 Dez 16 00:36 kubeadm*
-rwxr-xr-x 1 joma joma 111560216 Dez 16 00:37 kubelet*

$ ~/.minikube/cache/v1.17.0/kubeadm config images list
W0217 00:25:13.898021    4139 validation.go:28] Cannot validate kube-proxy config - no validator is available
W0217 00:25:13.898186    4139 validation.go:28] Cannot validate kubelet config - no validator is available
k8s.gcr.io/kube-apiserver:v1.17.3
k8s.gcr.io/kube-controller-manager:v1.17.3
k8s.gcr.io/kube-scheduler:v1.17.3
k8s.gcr.io/kube-proxy:v1.17.3
k8s.gcr.io/pause:3.1
k8s.gcr.io/etcd:3.4.3-0
k8s.gcr.io/coredns:1.6.5
```

See https://codefarm.me/2018/12/27/intall-minikube-with-kubeadm-on-debian/

### Where Is Kube-apiserver CLI In Minikube?

> kube-apiserver binary actually resides on particular container within K8s api-server Pod, therefore you can free to check it, just execute /bin/sh on that Pod
>
> ```sh
> $ kubectl exec -it $(kubectl get pods -n kube-system| grep kube-apiserver|awk '{print $1}') -n kube-system -- /bin/sh
>
> # kube-apiserver -h
>
> The Kubernetes API server validates and configures data
> for the api objects which include pods, services, replicationcontrollers, and
>
> You might be able to propagate the desired enable-admission-plugins through kube-apiserver command inside this Pod, however any modification will disappear once api-server Pod re-spawns, i.e. master node reboot, etc.
> The essential api-server config located in `/etc/kubernetes/manifests/kube-apiserver.yaml`. Node agent kubelet controls kube-apiserver runtime Pod, and each time when health checks are not successful kubelet sents a request to K8s Scheduler in order to re-create this affected Pod from primary kube-apiserver.yaml file.
> ...
> ```

See https://stackoverflow.com/a/56545286

```sh
$ minikube ssh
$ sudo cat /etc/kubernetes/manifests/kube-apiserver.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    component: kube-apiserver
    tier: control-plane
  name: kube-apiserver
  namespace: kube-system
spec:
...
    - --enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota
...
```

> The kube-apiserver is running in your kube-apiserver-< example.com > container. The application does not have a get method at the moment to obtain the enabled admission plugins, but you can get the startup parameters from its command line.

```sh
$ kubectl -n kube-system exec kube-apiserver-minikube -- sed 's/--/\n/g' /proc/1/cmdline
...
enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota
...
```

See https://stackoverflow.com/a/55220534

### How To Configure Kube-apiserver In Minikube

> The Kubernetes API server (Kube-apiserver) validates and configures data for the api objects which include pods, services, replicationcontrollers, and others. The API Server services REST operations and provides the frontend to the cluster’s shared state through which all other components interact.
>
> Minikube has a “configurator” feature that allows users to configure the Kubernetes components with arbitrary values. To use this feature, you can use the `–extra-config` flag on the minikube start command.
>
> `minikube start --extra-config=apiserver.anonymous-auth=false`

See https://evalle.xyz/posts/configure-kube-apiserver-in-minikube/

### How To Do File Sync In Minikube

> Place files to be synced in `$MINIKUBE_HOME/files`
>
> For example, running the following will result in the deployment of a custom /etc/resolv.conf:
>
> ```sh
> mkdir -p ~/.minikube/files/etc
> echo nameserver 8.8.8.8 > ~/.minikube/files/etc/resolv.conf
> minikube start
> ```

See

- https://suraj.io/post/apiserver-in-minikube-static-configs/
- https://github.com/kubernetes/minikube/issues/3559
- https://minikube.sigs.k8s.io/docs/tasks/sync/

### Where At The Host Can K8s Persistent Volumes Be Found

```yaml
...
// postgres-deployment.yml
    volumes:
        - name: postgres-storage
          persistentVolumeClaim:
            claimName: database-persistent-volume-claim
    containers:
    ...
        volumeMounts:
        - name: postgres-storage
            mountPath: /var/lib/postgresql/data
            subPath: postgres
...

// database-persistent-volume-claim.yml
...
kind: PersistentVolumeClaim
metadata:
  name: database-persistent-volume-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
...
```

```sh
$ kubectl describe pvc
Name:          database-persistent-volume-claim
...
Volume:        pvc-a9e657f3-d591-45c5-8faf-d6aa09cbd6e7
...
Capacity:      1Gi
Access Modes:  RWO
VolumeMode:    Filesystem
Mounted By:    postgres-deployment-7bb4cc6c95-tmfh9
...
  Normal  ProvisioningSucceeded  17m                k8s.io/minikube-hostpath 60afeb38-54c4-11ea-a189-080027383d5a  Successfully provisioned volume pvc-a9e657f3-d591-45c5-8faf-d6aa09cbd6e7

$ kubectl describe pv
Name:            pvc-a9e657f3-d591-45c5-8faf-d6aa09cbd6e7
Labels:          <none>
Annotations:     ...
                 pv.kubernetes.io/provisioned-by: k8s.io/minikube-hostpath
...
Claim:           default/database-persistent-volume-claim
...
Source:
    Type:          HostPath (bare host directory volume)
    Path:          /tmp/hostpath-provisioner/pvc-a9e657f3-d591-45c5-8faf-d6aa09cbd6e7
    HostPathType:
...

$ minikube ssh

$ ls -altr /tmp/hostpath-provisioner/pvc-a9e657f3-d591-45c5-8faf-d6aa09cbd6e7
total 12
drwxr-xr-x  3 root root 4096 Feb 21 18:54 ..
drwxrwxrwx  3 root root 4096 Feb 21 18:54 .
drwx------ 19  999 root 4096 Feb 21 18:54 postgres
```
