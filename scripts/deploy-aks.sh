#!/bin/bash

cd ~/az-infra-lab/infrastructure/aks
tf_init=$(terraform init)
echo $tf_init
echo "Terraform init started"
terraform apply -auto-approve
