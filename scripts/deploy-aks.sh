#!/bin/bash

cd ~/az-infra-lab/infrastructure/aks
tf_init=$(terraform init)
echo $tf_init
echo "Terraform init started"
terraform apply -auto-approve
mv ./priv-cluster-setup/route-table.tf .
terraform apply -auto-approve
az aks update -g $TF_VAR_trainee_name-eon-lab-gwc-aks-rg -n $TF_VAR_trainee_name-eon-lab-gwc-1-aks --outbound-type userDefinedRouting
mv ./priv-cluster-setup/udr-cluster.tf .
mv ./lb-cluster.tf ./priv-cluster-setup/
terraform apply -auto-approve
