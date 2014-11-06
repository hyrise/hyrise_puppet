# -*- mode: ruby -*-
# vi: set ft=ruby :

# modify these variables to control the resources allocated to the machine:
VM_CPUS = "6"
VM_MEMORY = "4096" # MB

Vagrant.configure("2") do |config|
  config.vm.box = "hydev1310"
  config.vm.box_url = "http://upload.devdojo.de/hydev1310.box"

  config.vm.provider :virtualbox do |vb|
    vb.customize [ "modifyvm", :id, 
      "--memory", VM_MEMORY,
      "--name", "hyrise2",
      "--nicspeed1", 1000000,
      "--nicspeed2", 1000000,
      "--ioapic", "on",
      "--cpus", VM_CPUS ]
  end

  config.vm.network :private_network, ip: "192.168.200.10"

  config.vm.provision :shell, :inline => "apt-get update"
  config.vm.provision :shell, :path => "https://raw.githubusercontent.com/hyrise/hyrise/master/tools/install_ubuntu1310.sh"
  config.vm.provision :shell, :inline => "git clone --recursive https://github.com/hyrise/hyrise", :privileged => false
  config.vm.provision :shell, :path => "https://gist.github.com/bastih/8455924/raw/setup.sh", :privileged => false
end
