# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "hybox"
  config.vm.box_url = "http://upload.devdojo.de/hybox.box"

  #config.vm.share_folder("v-root", "/vagrant", ".", :nfs => true, :nfs_version => 3)
  #config.vm.boot_mode = "gui"
  
  config.vm.provider :virtualbox do |vb|
    vb.customize [ "modifyvm", :id, "--memory", "4096",
    "--name", "hyrise",
    "--nicspeed1", 1000000,
    "--nicspeed2", 1000000,
    "--cpus", "6" ]
  end


  config.vm.network :private_network, ip: "192.168.200.10"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.log_level = :debug
  end
end
