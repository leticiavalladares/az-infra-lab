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
export TF_VAR_private_dns_zone_id=$(az network private-dns zone list -g $TF_VAR_trainee_name-eon-lab-gwc-mc-aks-rg --query "[].id" --output tsv)
terraform apply -auto-approve
cd ./acr-images/linux/
ACR_RGNAME=$TF_VAR_trainee_name-eon-lab-gwc-aks-rg
ACR_NAME=$(az acr list --resource-group $ACR_RGNAME --query "[].name" --output tsv)
az acr build --registry $ACR_NAME --image hellofromnode:v1.0 .
cd ../windows/
git clone https://github.com/Azure-Samples/dotnetcore-docs-hello-world.git
cd ./dotnetcore-docs-hello-world/
az acr build --registry $ACR_NAME --image hellofromdotnet:v1.0 --platform windows --file Dockerfile.windows .
