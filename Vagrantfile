# -*- mode: ruby -*-
# vi: set ft=ruby :

BASE_BOX="debian/testing64"

Vagrant.configure("2") do |config|
   config.vm.box = BASE_BOX

   config.vm.define "bigbrother.clickdefense.in" do |bigbrother|
      bigbrother.vm.hostname = "bigbrother.clickdefense.test"  # TODO-oscar: to be abstracted
      bigbrother.vm.network "public_network", ip: "192.168.1.100", dev: "wlp0s20f3", bridge: "wlp0s20f3"

      # Bootstrap with some commodities
      config.vm.provision "bootstrap", type: :shell, path: "provision/shell/bootstrap.sh"

      # Ansible provisioner included creating a whole development environment
      bigbrother.vm.provision "ansible", type: "ansible" do |ansible| 
         ansible.playbook = "provision/ansible/rsyslog_docker_setup.yml"
         ansible.raw_ssh_args = [
            "-o", "StrictHostkeyChecking=no",
            "-i", ".vagrant/machines/bigbrother.clickdefense.in/virtualbox/private_key"
         ]
         ansible.verbose = "v"
      end
   end
end
