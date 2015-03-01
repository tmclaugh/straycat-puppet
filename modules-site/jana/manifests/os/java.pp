# == Class: jana::os::java
#
# Install and configure java
#
# === Parameters
#
# [*java_vendor*]
#   Vendor package to use.
#   Type: string
#
# === Examples
#
# class { '::jana::os::java': }
#
# === FIXME
#
# * need to host our own Oracle JDK package at some point to make that work.
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2015 Tom McLaughlin
#
class jana::os::java (
  $java_vendor = 'openjdk'
){

  validate_re($java_vendor, '^(openjdk|oracle)$')

  if $java_vendor == 'openjdk' {
    $java_package = 'java-1.7.0-openjdk'
    # I don't want to get into games with upstream regarding package
    # revisions.  If this becomes an issue we can host our own and peg the
    # version.
    $java_version = undef
  } else {
    #Oracle
    $java_package = 'jdk'
    $java_version = '1.7.0_71-fcs'
  }

  class { '::java':
    package => $java_package,
    version => $java_version
  }

}
