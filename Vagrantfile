Vagrant.configure("2") do |config|

  config.vm.network :forwarded_port, guest: 8080, host: 8080 # owncloud port

  config.vm.box = "opscode_ubuntu-12.04"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04-i386_chef-11.4.4.box"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe "nginx"
    chef.add_recipe "php"
    chef.add_recipe "php-modules"
    chef.add_recipe "database"
    chef.add_recipe "owncloud"
  end

end