# === Fact: centos_minor
#
# CentOS minor version
#
require 'facter'

Facter.add("centos_minor") do
  setcode do
    if Facter.value('operatingsystem') == "CentOS"
      @centos_minor = Facter.value('operatingsystemrelease').split('.')[1]
    end
  end
end