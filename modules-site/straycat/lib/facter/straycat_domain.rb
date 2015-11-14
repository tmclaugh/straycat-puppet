# === Fact: straycat_domain
#
# Network domain sans DC name.
#
# Our DNS naming scheme.
#
# Public infrastructure:
# foo.straycat.dhs.org    CNAME to prod service
# foo.straycat-test.dhs.org CNAME to test service
# foo.<aws_region>.straycat-net.dhs.org
#
# Private infrastructure:
# foo.straycat.lan        CNAME to prod service
# foo.straycat-test.lan     CNAME to QA service
# foo.straycat-net.lan
#
# Local dev:
# foo.straycat.dev
# foo.straycat-net.dev  <- should investigate this idea
#
require 'facter'

Facter.add('straycat_domain') do
  setcode do
    if Facter.value('domain') == 'straycat.dev'
      Facter.value('domain')
    elsif Facter.value('domain') == 'straycat-net.lan'
      Facter.value('domain')
    elsif Facter.value('domain').split('.')[1..-1].join('.') == 'straycat-net.dhs.org'
      'straycat-net.dhs.org'
    end
  end
end