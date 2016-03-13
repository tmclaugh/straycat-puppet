# == Class: straycat::os::packages
#
# Ensure some basic packages.  These packages should be added to our base
# image.
#
# === Examples
#
# class { '::straycat::os::packages': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2016 Tom McLaughlin
#
class straycat::os::packages {

  $packages = [
                'curl',
                'iftop',
                'htop',
                'lsof',
                'python-boto',
                'sudo',
                'tcpdump',
                'tmux',
                'vim-minimal',
                'wget'
              ]

  package { $packages:
    ensure => installed
  }

  package { 'awscli':
    ensure   => '1.10.12',
    provider => pip,
    require  => Package['python-boto']
  }

}

