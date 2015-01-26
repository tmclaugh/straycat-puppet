# Example for provisioning multiple hosts.
Vagrant.configure('2') do |config|
  # primary: designates this will be the default host when no hostname is
  # given to commands.
  config.vm.define "node1", primary: true do |node1|
    node1.vm.hostname = 'node1.straycat.local'
    node1.vm.network "private_network", ip: "192.168.3.10"
  end

  config.vm.define "node2" do |node2|
    node2.vm.hostname = 'node2.straycat.local'
    node2.vm.network "private_network", ip: "192.168.3.11"
  end
end
