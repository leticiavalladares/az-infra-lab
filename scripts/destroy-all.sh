#!/bin/bash

cd ~/az-infra-lab/infrastructure/aks
terraform destroy -auto-approve
echo "Terraform destroy for AKS completed"
cd ~/az-infra-lab/infrastructure
terraform destroy -auto-approve
echo "Terraform destroy for the rest of resources completed"
