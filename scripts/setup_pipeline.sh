#!/bin/bash
# Installing Google Cloud SDK (gcloud command)
curl -o /tmp/google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-232.0.0-linux-x86_64.tar.gz
tar -xvf /tmp/google-cloud-sdk.tar.gz -C /tmp/
/tmp/google-cloud-sdk/install.sh -q
source /tmp/google-cloud-sdk/path.bash.inc
ln -s /tmp/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud

# Authenticate gcloud
echo $GCP_KEYFILE > /tmp/keyfile.json
gcloud auth activate-service-account bitbucket-pipelines@pinapp-222219.iam.gserviceaccount.com --project=pinapp-222219 --key-file=/tmp/keyfile.json
rm /tmp/keyfile.json

# Authenticating Docker to push to Google Cloud Registry images
echo $GCP_KEYFILE | docker login -u _json_key --password-stdin https://gcr.io

# Installing Kubernetes cli
gcloud components install kubectl --quiet
ln -s /tmp/google-cloud-sdk/bin/kubectl /usr/local/bin/kubectl
