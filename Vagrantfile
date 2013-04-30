# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "quantal64"
  config.vm.share_folder("v-root", "/vagrant", ".", :nfs => true, :nfs_version => 3)
  #config.vm.boot_mode = "gui"
  
  config.vm.customize [
    "modifyvm", :id,
    "--memory", "4096",
    "--name", "hyrise",
    "--nicspeed1", 1000000,
    "--nicspeed2", 1000000,
    "--cpus", "2"
  ]

  config.vm.box_url = "https://github.com/downloads/roderik/VagrantQuantal64Box/quantal64.box"
  config.vm.network :hostonly, "192.168.200.10"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
  end
end
