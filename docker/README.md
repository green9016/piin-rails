## Development

Run this only once (or every time the `docker/development/Dockerfile` is updated):

```shell
docker-compose build
```

Run these three commands only once:

```shell
docker-compose run app rails db:create
```

```shell
docker-compose run app rails db:schema:load
```

```shell
docker-compose run app rails db:seed
```

Run this every time a new migration is added:

```shell
docker-compose run app rails db:migrate
```

Run this command to start the rails app:

```shell
docker-compose up
```

## Production

Building the Docker image and uploading it to Google Cloud.
We'll use this image in the Kubernetes Cluster.

```shell
docker build -t gcr.io/pinapp-222219/pin-backend-production -f docker/production/Dockerfile .
docker push gcr.io/pinapp-222219/pin-backend-production

docker run gcr.io/pinapp-222219/pin-backend-production
```

### Kubernetes

This command installs the Kubernetes component to `glcoud` cli 

```shell
gcloud components install kubectl
```

Creating the cluster.

```shell
gcloud container clusters create pin-backend-production \
    --scopes "cloud-platform,userinfo-email" \
    --num-nodes 2 \
    --machine-type n1-standard-1 \
    --enable-basic-auth \
    --issue-client-certificate \
    --enable-ip-alias \
    --enable-autorepair \
    --zone us-east1-b
    
kubectl get nodes --cluster gke_pinapp-222219_us-east1-b_pin-backend-production
```

Upgrading the cluster (this is needed in case we run out of resources).

```shell
gcloud compute instance-groups managed resize gke-pin-backend-producti-default-pool-5f404171-grp --size=2 --zone=us-east1-b
```

Creating the Deployment.

```shell
kubectl create --save-config -f docker/production/pin-backend-secrets.yaml --cluster gke_pinapp-222219_us-east1-b_pin-backend-production
kubectl create --save-config -f docker/production/pin-backend.yaml --cluster gke_pinapp-222219_us-east1-b_pin-backend-production
kubectl get deployments --cluster gke_pinapp-222219_us-east1-b_pin-backend-production
kubectl get pods --cluster gke_pinapp-222219_us-east1-b_pin-backend-production
kubectl describe pods --cluster gke_pinapp-222219_us-east1-b_pin-backend-production
```

Creating the Service

```shell
kubectl create -f docker/production/pin-backend-service.yaml --cluster gke_pinapp-222219_us-east1-b_pin-backend-production
```

Scaling the Deployment.

```shell
kubectl scale deployments/pin-backend --replicas=3 --cluster gke_pinapp-222219_us-east1-b_pin-backend-production
```

Upgrading (deploying) using the Rollout strategy.

```shell
kubectl set image deployments/pin-backend pin-backend=gcr.io/pinapp-222219/pin-backend-production@sha256:247c19c927c1ea2211ebb95be445e062cc9bfa09cbb6d957e9ac428af3d5a54c --cluster gke_pinapp-222219_us-east1-b_pin-backend-production
```

Deleting the Deployment, the Service and the whole cluster.

```shell
kubectl delete deployments pin-backend --cluster gke_pinapp-222219_us-east1-b_pin-backend-production
kubectl delete services pin-backend --cluster gke_pinapp-222219_us-east1-b_pin-backend-production
gcloud container clusters delete pin-backend-production --zone us-east1-b
```

Cloud Storage bucket (don't know why I saved this command here).

```shell
gsutil mb gs://pin-backend-production
gsutil defacl set public-read gs://pin-backend-production
```

## Staging

```shell
docker build -t gcr.io/pinapp-222219/pin-backend-staging -f docker/staging/Dockerfile .
docker push gcr.io/pinapp-222219/pin-backend-staging

gcloud container clusters create pin-backend-staging \
    --scopes "cloud-platform,userinfo-email" \
    --num-nodes 1 \
    --machine-type g1-small \
    --enable-basic-auth \
    --issue-client-certificate \
    --enable-ip-alias \
    --enable-autorepair \
    --zone us-east1-b
    
kubectl create --save-config -f docker/staging/pin-backend-secrets.yaml --cluster gke_pinapp-222219_us-east1-b_pin-backend-staging
kubectl create -f docker/staging/pin-backend.yaml --cluster gke_pinapp-222219_us-east1-b_pin-backend-staging

kubectl create -f docker/staging/pin-backend-service.yaml --cluster gke_pinapp-222219_us-east1-b_pin-backend-staging
```

Force deploy 2
