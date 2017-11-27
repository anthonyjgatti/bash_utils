#!/bin/bash

# Requied: aws cli install and kops.

# Rebuild bucket if need be.
# aws s3api create-bucket \
#    --bucket sdc-demo-store-state \
#    --region us-east-2 \
#    --create-bucket-configuration LocationConstraint=us-east

if [ "$1" == "provision" ]; then

export KOPS_STATE_STORE=s3://sdc-demo-store-state

mkdir -p ./kube/dev.sdcdemo.io
touch ./kube/dev.sdcdemo.io/kubeconfig
EXPORT KUBECONFIG="./kube/dev.sdcdemo.io/kubeconfig"

#mkdir credentials
#ssh-keygen -t rsa

kops create cluster cluster.k8s.local \
  --v=0 \
  --cloud=aws \
  --node-count 2 \
  --master-size=t2.micro \
  --master-zones=us-east-2a \
  --zones us-east-2a,us-east-2b \
  --node-size=t2.micro

elif [ "$1" == "destroy" ]; then

  kops delete cluster cluster.k8s.local --yes
  aws s3api delete-bucket --bucket ${KOPS_STATE_STORE}

fi



kops update cluster dev.sdcdemo.io

# kops delete cluster dev.sdcdemo.io
