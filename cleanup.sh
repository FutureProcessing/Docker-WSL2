#!/usr/bin/env bash

set -e

source ./variables.env

echo "Stoping docker service"
sudo service docker stop || true

echo "Removing current user form docker group"
sudo gpasswd -d $(whoami) docker || true

echo "Removin Docker CE"
sudo apt purge --yes docker-ce*

echo "Removing APT Docker list"
if [[ -f $DOCKER_LIST_PATH ]]; then
  sudo rm -rf  $DOCKER_LIST_PATH > /dev/null
  sudo apt update --yes
fi

echo "Removing Docker archive keyring"
if [[ -f $DOCKER_KEYRING_PATH ]]; then
  sudo rm -rf $DOCKER_KEYRING_PATH
fi
