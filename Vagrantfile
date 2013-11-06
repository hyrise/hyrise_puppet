# -*- mode: ruby -*-
# vi: set ft=ruby :

# VM hardware settings; override via environment
#  defaults: VM_CPUS = 6; VM_MEMORY = 4096
VM_CPUS = (ENV['VM_CPUS'] ? ENV['VM_CPUS'] : "6");
VM_MEMORY = (ENV['VM_MEMORY'] ? ENV['VM_MEMORY'] : "4096");

Vagrant.configure("2") do |config|
  config.vm.box = "hybox"
  config.vm.box_url = "http://upload.devdojo.de/hybox.box"

  config.vm.synced_folder "hyrise/", "/home/vagrant/hyrise"
  
  config.vm.provider :virtualbox do |vb|
    vb.customize [ "modifyvm", :id, "--memory", VM_MEMORY,
    "--name", "hyrise",
    "--nicspeed1", 1000000,
    "--nicspeed2", 1000000,
    "--ioapic", "on",
    "--cpus", VM_CPUS ]
  end

  config.vm.provision :shell, :inline => "apt-get update"

  config.vm.network :private_network, ip: "192.168.200.10"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
  end
end
