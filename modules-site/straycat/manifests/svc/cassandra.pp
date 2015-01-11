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
# === FIXME:
#
# * Cassandra wants Oracle Java but we only have OpenJDK.  With a mirror in
#   place we'd be able to provide that package.
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
  $cassandra_seeds        = [$::ipaddress_eth0],
  $cassandra_version      = '2.1.2-1',
) {

  validate_string($cluster_name, $cassandra_version)
  validate_array($cassandra_seeds)

  # Class[::cassandra] defaults to 0.0.0.0 but service start fails because
  # broadcast_rpc_address cannot be a broadcast.  Class does not provide the
  # ability to alter that value.  Rather than fork module set the
  # rpc_address to eth0 for now till there's a reason to handle multiple
  # interfaces.
  $rpc_address = $::ipaddress_eth0

  # Prevent OOM in low memory situations.
  #
  # Cassandra environment script does its own calculations but in low memory
  # situation was still OOMing.  Eventually we should tune for larger systems
  # but for now let's get working.
  #
  if $::memorysize_mb < 2500 {
    # Still very close to limit especially when Puppet runs.
    $max_heap_size_val   = $::memorysize_mb / 2.5
    # Next two lines are a poor man's int()
    $max_heap_size_array = split("${max_heap_size_val}", '\.')
    $max_heap_size_int   = $max_heap_size_array[0]
    $max_heap_size       = "${max_heap_size_int}M"

    # Must be set if $max_heap_size is set.  Below is how Cassandra
    # calculates the value.
    $heap_newsize_val  = 100 * $::processorcount
    $heap_newsize      = "${heap_newsize_val}M"
  } else {
    $max_heap_size = undef
    $heap_new_size = undef
  }

  ensure_resource('class', '::straycat::os::java')

  class { '::cassandra':
    cluster_name  => $cluster_name,
    max_heap_size => $max_heap_size,
    heap_newsize  => $heap_newsize,
    package_name  => $cassandra_package_name,
    rpc_address   => $rpc_address,
    seeds         => $cassandra_seeds,
    version       => $cassandra_version,
    require       => Class['::straycat::os::java']
  }
}
