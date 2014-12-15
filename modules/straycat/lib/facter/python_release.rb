# === Fact: python_release
#
# CentOS RPM release (ex. el6, el7)
#
require 'facter'

Facter.add('python_ver') do
  setcode do
    if Facter.value('centos_major') == '7'
      '2.7'
    elsif Facter.value('centos_major') == '6'
      '2.6'
    else
      nil
    end
  end
end