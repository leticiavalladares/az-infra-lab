#!/bin/bash

apt update & apt upgrade
apt install apt-transport-https curl wget git vim -y
apt install docker.io -y
systemctl enable docker
systemctl start docker
apt update && apt install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
tee /etc/apt/sources.list.d/hashicorp.list
apt update
apt install terraform
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
DEBIAN_FRONTEND=noninteractive apt-get -y install xfce4
apt install xfce4-session
apt-get -y install xrdp
systemctl enable xrdp
adduser xrdp ssl-cert
echo xfce4-session >~/.xsession
service xrdp restart
