# == Class: straycat::os::python
#
# Install and configure Python
#
# === Examples
#
# class { '::straycat::os::python': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2016 Tom McLaughlin
#
class straycat::os::python {

  class { '::python':
    pip        => true,
    dev        => true,
    virtualenv => false
  }
  contain ::python

  # Work around bug in pip provider that does not reflect later RHEL.
  file { '/usr/bin/pip-python':
    ensure => link,
    target => '/usr/bin/pip'
  }

}
