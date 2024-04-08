#!/bin/bash

cd ~/az-infra-lab/infrastructure/aks
tf_init=$(terraform init)
echo $tf_init
echo "Terraform init started"
terraform apply -auto-approve
mv ./priv-cluster-setup/udr-cluster.tf .
mv ./lb-cluster.tf ./priv-cluster-setup/
terraform apply -auto-approve
