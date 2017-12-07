#!/bin/bash

cd /src
cp components/hab/install.sh /tmp/
sh support/linux/install_dev_0_ubuntu_latest.sh
sh support/linux/install_dev_9_linux.sh
. ~/.profile
make build

apt-get install ntp -y
systemctl restart ntp

source /scripts/my.env

echo "auth_token = '${HAB_AUTH_TOKEN}'
bldr_url = '${HAB_BLDR_URL}'
auto_publish = true
key_dir = '/hab/cache/keys'
" > /config/config_worker.toml

echo 'source /scripts/env.sh' >> ~/.bashrc
source ~/.bashrc

hab user key generate bldr
source /src/terraform/scripts/worker_bootstrap.sh
