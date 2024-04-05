#!/bin/bash

cd ~/az-infra-lab/infrastructure/infra-foundation
tf_init=$(terraform init)
echo $tf_init
echo "Terraform init started"
terraform apply -auto-approve
