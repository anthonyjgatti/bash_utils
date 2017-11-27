#!/bin/bash

# Install virtual box - CHECK IF EXISTS?
# sudo apt-get install virtualbox

# Download Kubernetes.
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo chown anthony:anthony /usr/local/bin/kubectl

# Download Minikube.
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 
chmod +x minikube 
sudo mv minikube /usr/local/bin/
sudo chown anthony:anthony /usr/local/bin/minikube
sudo chown anthony:anthony /usr/local/bin/localkube
chmod +x /usr/local/bin/localkube

# Download kops.
wget https://github.com/kubernetes/kops/releases/download/1.7.0/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops
sudo chown anthony:anthony /usr/local/bin/kops

# Change ownership of necessary directories.
sudo chown -R anthony:anthony /home/anthony/.minikube/
sudo chown -R anthony:anthony /home/anthony/.kube/

# minikube start

