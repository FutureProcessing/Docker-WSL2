#!/usr/bin/env bash

DOCKER_LIST_PATH="/etc/apt/sources.list.d/docker.list"
if [[ ! -f $DOCKER_LIST_PATH ]]; then
  curl -kfsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --quiet --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee $DOCKER_LIST_PATH > /dev/null
  sudo apt update --yes
fi

sudo apt install --yes docker-ce

sudo usermod -aG docker $(whoami)

sudo service docker start

docker info  --format "Docker Server version: {{.ServerVersion}}"
