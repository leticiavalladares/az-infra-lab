#!/bin/bash

cd ~/az-infra-lab/infrastructure/aks
tf_init=$(terraform init)
echo $tf_init
echo "Terraform init started"
terraform apply -auto-approve
cd ./acr-images/linux/
ACR_RGNAME=$TF_VAR_trainee_name-eon-lab-gwc-aks-rg
ACR_NAME=$(az acr list --resource-group $ACR_RGNAME --query "[].name" --output tsv)
az acr build --registry $ACR_NAME --image hellofromnode:v1.0 .
cd ..
mkdir windows
cd ./windows/
git clone https://github.com/Azure-Samples/dotnetcore-docs-hello-world.git
cd ./dotnetcore-docs-hello-world/
az acr build --registry $ACR_NAME --image hellofromdotnet:v1.0 --platform windows --file Dockerfile.windows .
