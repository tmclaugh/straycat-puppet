# == Class: straycat::svc::phppgadmin
#
# Setup the PostgreSQL service
#
# === Parameters
#
# [*pgsql_datadir*]
#   Location of postgresql data.
#   Type: string
#
# [*pgsql_listen_addressr*]
#   Address Postgresql should listen on.
#   Type: string
#
# [*pgsql_config_entries*]
#   Additional configuration to pass to Class['::postgresql']
#   Type: hash
#
# === Examples
#
#   class { '::straycat::svc::postgresql': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::svc::phppgadmin (
  $pgsql_db_host = undef,
  $pgsql_db_port = undef
) {

  # FIXME: Apache should have own service class. Maybe even nginx instead.
  # FIXME: Add SSL support.
  include ::apache
  include ::apache::mod::php
  apache::vhost { 'phpPgAdmin':
    docroot    => '/usr/share/phpPgAdmin',
    servername => $::fqdn,
    port       => '80'
  }

  # FIXME: We're not bothering to manage or tune php but could.
  class { '::phppgadmin':
    user        => 'apache',
    use_package => true,
    servers     => [
      {
        desc => $pgsql_db_host,
        host => $pgsql_db_host,
        #port => $pgsql_db_port   # FIXME: Module does not support this.
      },
    ]
  }

}
