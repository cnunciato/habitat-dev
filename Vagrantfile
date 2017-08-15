Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.10"

  config.vm.synced_folder "./",                 "/support"
  config.vm.synced_folder "~/.hab/cache/keys",  "/hab/cache/keys"
  config.vm.synced_folder "./pkgs",             "/hab/cache/artifacts"
  config.vm.synced_folder "./config",           "/config"
  config.vm.synced_folder "./scripts",          "/scripts"
  config.vm.synced_folder "../habitat",         "/src"
  config.vm.synced_folder "../core-plans",      "/core-plans"

  config.vm.provision "shell", path: "./scripts/provision.sh", privileged: true

  # For builder-web
  # config.vm.network "forwarded_port", guest: 3000, host: 3000, autocorrect: true

  # For builder-api
  config.vm.network "forwarded_port", guest: 9636, host: 9636

  # For builder-db
  config.vm.network "forwarded_port", guest: 5432, host: 5432

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 4
  end
end
