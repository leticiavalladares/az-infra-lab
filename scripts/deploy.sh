#!/bin/bash

cd ~/az-infra-lab/infrastructure/
tf_init=$(terraform init)
echo $tf_init
tf_plan=$(terraform plan)
echo $tf_plan
tf_apply=$(terraform apply -auto-approve)
echo $tf_apply
tf_output=$(terraform output public_ip)
echo $tf_public_ip
