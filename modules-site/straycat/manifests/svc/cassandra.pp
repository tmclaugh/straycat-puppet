# == Class: straycat::svc::cassandra
#
# Setup a Cassandra DB node
#
# === Parameters
#
# [*cluster_name*]
#   Name of Cassandra cluser.
#   Type: string
#
# [*cassandra_package_name*]
#   DataStax Community Edition package name.  The name includes a version
#   which must correspond with the value of $cassandra_version.
#   Type: string
#
# [*cassandra_seeds*]
#   Array of IPs that are cluster seeds.
#   NOTE: This must be IPs, not hostnames.
#   Type: array
#
# [*cassandra_version*]
#   Package version to install.  Must correspond with the value of
#   $cassandra_package_name.
#   Type: string
#
# === Examples
#
# class { 'straycat::svc::cassandra':
#   cluster_name => 'myCluster'
# }
#
# === TODO
#
# * Figure out how to do overrides for cluster name and seeds.  Hiera? ENC?
#   both?
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2015 Tom McLaughlin
#
class straycat::svc::cassandra (
  $cluster_name           = undef,
  $cassandra_package_name = 'dsc21',
  $cassandra_seeds        = undef,
  $cassandra_version      = '2.1.2-1',
) {

  validate_string($cluster_name, $cassandra_version)
  validate_array($cassandra_seeds)

  class { '::straycat::os::java': }
  contain ::straycat::os::java

  class { '::cassandra':
    cluster_name => $cluster_name,
    package_name => $cassandra_package_name,
    seeds        => $cassandra_seeds,
    version      => $cassandra_version
  }
}
