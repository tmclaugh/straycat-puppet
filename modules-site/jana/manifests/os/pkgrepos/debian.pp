# == Class: jana::os::pkgrepos::debian
#
# Configure basic Debian repos
#
# === Examples
#
# class { '::jana::os::pkgrepos::debian' }
#
# === Authors
#
# Tom McLaughlin <tom@jana.com>
#
# === Copyright
#
# Copyright 2015 Tom McLaughlin
#
class jana::os::pkgrepos::debian {

  apt::source { $::lsbdistcodename:
    comment  => "Packages for ${::lsbdistcodename}",
    location => 'http://http.debian.net/debian',
    repos    => 'main',
  }

  apt::source { "${::lsbdistcodename}-updates":
    comment  => "Update packages for ${::lsbdistcodename}",
    release  => "${::lsbdistcodename}-updates",
    location => 'http://http.debian.net/debian',
    repos    => 'main',
  }

  apt::source { "${::lsbdistcodename}-security":
    comment  => "Security update packages for ${::lsbdistcodename}",
    release  => "${::lsbdistcodename}/updates",
    location => 'http://security.debian.org/',
    repos    => 'main',
  }

}
