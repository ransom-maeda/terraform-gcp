# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
VAGRANT_COMMAND = ARGV[0]
FILE_TO_DISK = '.vagrant/machines/default/virtualbox/os2nd.vdi'

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/xenial64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "10.10.11.11", auto_config: true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  if Vagrant::Util::Platform.windows? then
    config.vm.synced_folder ".", "/terraform-gcp", type: "smb"
  else
    config.vm.synced_folder ".", "/terraform-gcp",
    type: "nfs",
    nfs: true,
    nfs_version: 3,
    nfs_udp: false,
    linux__nfs_options: ['rw','no_subtree_check','all_squash','async'],
    mount_options: ['rw', 'vers=3', 'tcp', 'fsc' ,'actimeo=2']
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
    vb.name = "osk8s16.04"
     # Customize the amount of memory on the VM:
    vb.cpus = "3"
    vb.memory = "5120"
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--vram", "16"]

    # print "VAGRANT_COMMAND = #{VAGRANT_COMMAND}\n"
    if VAGRANT_COMMAND == "up" && ! File.exists?(FILE_TO_DISK)
      # print "Creating /dev/sdc ...\n"
      vb.customize ['createhd', '--filename', FILE_TO_DISK, '--size', 50 * 1024]
      vb.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', FILE_TO_DISK] # will be /dev/sdc
    end
  end

  config.vm.hostname = "osk8s"
  config.ssh.pty = false
end
