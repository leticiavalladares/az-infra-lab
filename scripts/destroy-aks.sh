#!/bin/bash

cd ~/az-infra-lab/infrastructure/aks
terraform destroy -auto-approve
echo "Terraform destroy for AKS completed"
