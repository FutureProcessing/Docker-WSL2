#!/usr/bin/env bash

set -e

DOCKER_KEYRING_PATH="/etc/apt/trusted.gpg.d/docker-archive-keyring.gpg"
DOCKER_LIST_PATH="/etc/apt/sources.list.d/docker.list"

echo "Adding Docker archive keyring"
if [[ ! -f $DOCKER_KEYRING_PATH ]]; then
  curl -kfsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --quiet --dearmor -o $DOCKER_KEYRING_PATH
fi

echo "Adding APT Docker list"
if [[ ! -f $DOCKER_LIST_PATH ]]; then
  echo "deb [arch=amd64 signed-by=${DOCKER_KEYRING_PATH}] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee $DOCKER_LIST_PATH > /dev/null
  sudo apt update --yes
fi

echo "Installing Docker CE"
sudo apt install --yes docker-ce

echo "Adding current user do docker group"
sudo usermod -aG docker $(whoami)

echo "Starting docker service"
sudo service docker start

sudo docker info  --format "Docker Server version is {{.ServerVersion}}"
