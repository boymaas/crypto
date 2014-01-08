# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.


  config.vm.define :crypto_development do |development|
    # The url from where the 'config.vm.box' box will be fetched if it
    # doesn't already exist on the user's system.
    # default.vm.box_url = "http://domain.com/path/to/above.box"
    #
    # Every Vagrant virtual environment requires a box to build off of.
    development.vm.box = "precise32"

    # View the documentation for the provider you're using for more
    # information on available options.
    development.vm.provision :shell, :path => 'provision/bootstrap.sh'

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    development.vm.network :forwarded_port, guest: 80, host: 8080

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    development.vm.network :private_network, ip: "192.168.33.10"

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    # default.vm.synced_folder "../data", "/vagrant_data"
    development.vm.synced_folder "../crypto_trader", "/crypto_trader"
  end


  config.vm.define :crypto_production do |production|
    production.vm.provision :shell, :path => 'provision/bootstrap.sh'

    production.vm.provider :digital_ocean do |provider, override|
      override.ssh.private_key_path = '~/.ssh/id_rsa'
      override.vm.box = 'digital_ocean'
      override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"

      provider.image = "Ubuntu 12.04.3 x32"
      provider.region = "New York 2"

      provider.client_id = "djMb4jN3jCDeKuzCNhY5K"
      provider.api_key = "2d449f5aef421e18cbb4dd72f5834a9d"
    end
  end

end
