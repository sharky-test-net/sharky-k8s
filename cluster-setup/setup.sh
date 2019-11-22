#!/bin/bash

# add some rights for current Gcloud user
kubectl create clusterrolebinding \
  cluster-admin-binding \
  --clusterrole=cluster-admin \
  --user=$(gcloud config get-value core/account)

# creating necessary namespaces
kubectl create -f ./sharky-ui-namespace.yaml
kubectl create -f ./cert-manager-namespace.yaml

# installing cert-manager
kubectl apply \
  --validate=false \
  -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager \
  jetstack/cert-manager \
  --namespace cert-manager \
  --version v0.11.0 \
  --set webhook.enabled=false

export PROJECT_NAME="[YOUR_PROJECT_NAME]"

# create service account
gcloud iam service-accounts create k8s-cert-manager \
  --display-name="Service Account to manage SSL Certificates." \
  --project=$PROJECT_NAME

# create and download service account key
gcloud iam service-accounts keys create ./credentials.json \
  --iam-account=k8s-cert-manager@$PROJECT_NAME.iam.gserviceaccount.com \
  --project=$PROJECT_NAME

# give dns admin permissions
gcloud projects add-iam-policy-binding $PROJECT_NAME \
  --member=serviceAccount:k8s-cert-manager@$PROJECT_NAME.iam.gserviceaccount.com \
  --role=roles/dns.admin

# Create secret from GCP service account
kubectl create secret generic cert-manager \
  --from-file=./credentials.json \
  --namespace=cert-manager

# Make sure to update below .yaml files - `project` should be set to a proper value.
# Create ClusterIssuer — Staging, and Production
kubectl apply -f clusterissuer-staging.yaml
kubectl apply -f clusterissuer-production.yaml
