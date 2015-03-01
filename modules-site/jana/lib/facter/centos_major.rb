# === Fact: centos_major
#
# CentOS major version
#
require 'facter'

Facter.add("centos_major") do
  setcode do
    if Facter.value('operatingsystem') == "CentOS"
      @centos_major = Facter.value('operatingsystemrelease').split('.')[0]
    end
  end
end