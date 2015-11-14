# == Profile: memcached-multi
#
# Instantiates multiple memcached hosts.  This profile is specifically for
# creating multiple hosts for testing and understanding when behavior using
# multiple memcached hosts.  For a single memcached host, for example to
# test puppet changes only, use:
#
# $ rake vagrant:up[<instance_name>] role=role_memcached
#
#
# NOTE: when prompted for a password during host provisioning enter your
# local user's password.  this is necessary to update /etc/hosts so that
# name resolution works for clients.
#
# Example:
# ==> mcd-1: Updating /etc/hosts file on host machine (password may be required)...
# Password:
#
# === Usage
#
# ==== Create hosts
#
# Start a set of memcached instances.  The number of instances is determined
# by ROLES below.
# $ rake vagrant:up[<instance_name>] profile=memcached-multi
#
#
# ==== Simulate node connectivity issue
#
# Suspend an instance
# $ rake vagrant:suspend[<instance_name>,<instance_name>-<#>]
#
# Returning suspended node to service:
# $ rake vagrant:resume[<instance_name>,<instance_name>-<#>]
#
#
# ==== Simulate node loss
#
# Destroy instance
# $ rake vagrant:destroy[<instance_name>,<instance_name>-<#>]
#
# Provision replacement instance
# $ rake vagrant:up[<instance_name>,<instance_name>-<#>]
#
#
# ==== Client access.
#
# This profile will manipulate the /etc/hosts file on instances and the
# local host so that name resolution will work.  Client's can access a
# memcahced instance by connecting to:
#
# <instance_name>-<#>.straycat.dev:11211
#
Vagrant.configure('2') do |config|
  NODES = 3

  # Manage entries for instances on local host.
  config.hostmanager.manage_host = $hosmanager_manage_host

  (1..NODES).each do |i|
    config.vm.define "#{$inst_name}-#{i}" do |mc|

      mc.vm.hostname = "#{$inst_name}-#{i}.straycat.dev"
      mc.hostmanager.aliases = "#{$inst_name}-#{i}"

      # This is an ugly hack until I figure out how to make VirtualBox DHCP
      # reliably work on any person's machine.
      mc.vm.network "private_network", type: "dhcp"

    end
  end
end