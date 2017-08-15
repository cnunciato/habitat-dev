#!/bin/bash

cd /src
cp components/hab/install.sh /tmp/
sh support/linux/install_dev_0_ubuntu_latest.sh
sh support/linux/install_dev_9_linux.sh
. ~/.profile
make

apt-get install httpie -y
source /scripts/my.env

echo "auth_token = '${HAB_AUTH_TOKEN}'
depot_url = '${HAB_DEPOT_URL}'
auto_publish = true
" > /config/config_worker.toml

echo 'source /scripts/env.sh' >> ~/.bashrc
source ~/.bashrc
