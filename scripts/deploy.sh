#!/bin/bash

cd ~/az-infra-lab/infrastructure/
tf_init=$(terraform init)
echo $tf_init
echo "Terraform init started"
terraform apply -auto-approve
echo "Terraform apply started"
tf_output=$(terraform output public_ip)
echo "Terraform apply completed"
echo $tf_output
