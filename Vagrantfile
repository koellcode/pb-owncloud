Vagrant.configure("2") do |config|

  config.vm.box = "precise64"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
  end

end