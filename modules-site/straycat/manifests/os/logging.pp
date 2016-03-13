# == Class: straycat::os::logging
#
# Setup logging.
#
# === Examples
#
# class { '::straycat::os::logging': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2016 Tom McLaughlin
#
class straycat::os::logging {

  anchor { 'straycat::os::logging::start': }

  class { '::rsyslog::client':
    log_local           => true,
    rate_limit_interval => '5',
    rate_limit_burst    => '2500'
  }

  class { '::logrotate': }

  anchor { 'straycat::os::logging::end': }


  Anchor['straycat::os::logging::start'] ->
  Class['::rsyslog::client'] ->
  Class['::logrotate'] ->
  Anchor['straycat::os::logging::end']
}
