# == Class: class_name
#
# Short description of class.
#
# === Parameters
#
# [*parameter*]
#   Description of parameter and its usage.
#
# === Examples
#
#   class { 'class_name':
#     parameter => 'value'
#   }
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::svc::puppet::foreman {

  contain ::straycat::svc::passenger

  $foreman_repo    = 'releases/1.7'
  $foreman_version = '1.7.0-1.el6'

  $db_type     = 'mysql'
  $db_database = 'foreman'
  $db_host     = ''
  $db_port     = '3306'
  $db_username = 'app_foreman'
  $db_password = 'MyxhOg%0gz8T'

  $foreman_host     = 'foreman.hubteam.com'
  $maintenance_user = 'rainmaker'
  $maintenance_pass = 'd9F6UR!pSRH&'

  $ldap_hosts = hiera('hubspot::ldap::servers')
  $ldap_host = $ldap_hosts[0]
  $ldap_user = 'puppet'
  $ldap_pass = 'MyevhowsOws4'

}
