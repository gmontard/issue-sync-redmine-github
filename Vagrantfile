# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  ##### Custom Settings ####
  private_ip = ENV['VAGRANT_PRIVATE_IP'] || "10.0.0.102"
  cpu = ENV['VAGRANT_CPU'] || 4
  ram = ENV['VAGRANT_MEMORY'] || 4096

  config.vm.hostname = "vodev-box"

  config.vm.network "private_network", ip: private_ip

  config.vm.network "public_network", bridge: "en0: Ethernet"

  config.ssh.forward_agent = true
  #config.ssh.private_key_path = "~/.ssh/id_rsa"

  config.vm.synced_folder ".", "/vagrant", type: "nfs"

  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
    config.cache.enable :apt
    config.cache.enable :gem
    config.cache.synced_folder_opts = {
      type: :nfs,
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
  end

  # PostgreSQL was using LATIN1 instead of UTF-8 as a server_encoding value
  config.vm.provision :shell, :inline => "echo 'LC_ALL=\"en_US.UTF-8\"' > /etc/default/locale"

  # Provider-specific configuration.
  # For VirtualBox:
  config.vm.provider :virtualbox do |vm, override|
    override.vm.box = "precise64"
    override.vm.box_url = "http://files.vagrantup.com/precise64.box"
    vm.customize ["modifyvm", :id, "--memory", ram]
    vm.customize ["modifyvm", :id, "--cpus", cpu]
    #vm.gui = true # for debug
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/playbook.yml"
    ansible.sudo = true
    ansible.limit = "all"
    ansible.verbose = 'v'
  end
end
