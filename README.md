# sharky-k8s

k8s configs for cluster &amp; sharky services

## Prerequisites

- [helm v3](https://github.com/helm/helm/releases/tag/v3.0.0)
- [GCP sdk](https://cloud.google.com/sdk/install)
- Gmail account & IAM rights to work with `sharky-259408` GCP project

## Connect to cluster

```
gcloud auth login
gcloud init
gcloud components update
gcloud config set project sharky-259408
gcloud config set compute/zone us-central1-a
gcloud config set project us-central1
gcloud projects list
gcloud container clusters get-credentials sharky
kubectl top nodes
```
