Vagrant.configure("2") do |config|

  config.vm.box = "precise64"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe("apt")
    chef.add_recipe("nginx::default")
  end

end