#!/bin/bash

set -euo pipefail
set -x

kubectl -n scf scale statefulset blobstore --replicas=0
kubectl -n scf rollout status statefulset/blobstore -w

kubectl -n scf delete pvc blobstore-data-blobstore-0
kubectl -n scf scale statefulset blobstore --replicas=1

kubectl -n scf delete pod api-group-0
kubectl -n scf rollout status statefulset/api-group -w
fly -t flintstone tj -j "ci/run-core-cats-$(kubectl config current-context)"
