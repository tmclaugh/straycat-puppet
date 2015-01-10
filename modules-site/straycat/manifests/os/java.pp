# == Class: straycat::os::java
#
# Install and configure java
#
# === Parameters
#
# [*<paramater>*]
#   <parameter description>
#
# === Examples
#
# class { 'hubspot::classname':
#   param1 => value
# }
#
# === TODO
#
# * <things to do>
#
# === BUGS
#
# * <known issues>
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2015 Tom McLaughlin
#
class straycat::os::java {

  class { '::java':
    distribution => 'jre'
  }

}
