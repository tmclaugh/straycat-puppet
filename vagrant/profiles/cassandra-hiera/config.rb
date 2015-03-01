# == Profile: cassandra
#
# Provision a variable size Cassandra cluster.
#
# === FIXME
#
# * If hostmanager played well with DHCP I wouldn't need the stupid
#   addressing scheme below.
#

vg_seeds = 1  # Must update localVagrant.yaml with new seeds if this is adjusted
vg_nodes = 1

Vagrant.configure('2') do |config|
  (1..vg_seeds).each do |i|
    config.vm.define "seed-#{i}", primary: true do |seed|
      seed.vm.hostname = "cassandra-seed-#{i}.jana.local"
      seed.hostmanager.aliases = "cassandra-seed-#{i}"

      seed.vm.network "private_network", type: "dhcp"
    end
  end

  (1..vg_nodes).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.hostname = "cassandra-node-#{i}.jana.local"
      node.hostmanager.aliases = "cassandra-node-#{i}"

      node.vm.network "private_network", type: "dhcp"
    end
  end
end