#!/bin/bash

cd ~/az-infra-lab/infrastructure
terraform destroy -auto-approve
echo "Terraform destroy for infrastructure completed"
