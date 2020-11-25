Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "16384" 
    vb.cpus = "8"
  end
  config.disksize.size = "100GB"
  config.vm.define :firefox_vm do |t|
  end
end
