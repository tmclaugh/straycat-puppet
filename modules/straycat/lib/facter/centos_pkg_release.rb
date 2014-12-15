# === Fact: centos_pkg_release
#
# CentOS RPM release (ex. el6, el7)
#
require 'facter'

Facter.add('centos_pkg_release') do
  setcode do
    v = Facter.value("centos_major")
    "el#{v}"
  end
end
