# == Class: straycat::os::pkgrepos::centos
#
# Configure the upstream yum repo.
#
# === Parameters
#
# [*base_repo_enabled*]
#   Enable base CentOS repo.
#   Type: bool
#
# [*updates_repo_enabled*]
#   Enable updates CentOS repo.
#   Type: bool
#
# === Examples
#
# class { '::straycat::os::pkgrepos::centos' }
#
# === Authors
#
# Tom McLaughlin <tmclaughlin@hubspot.com>
#
# === Copyright
#
# Copyright 2013 Hubspot
#
class straycat::os::pkgrepos::centos (
  $base_repo_enabled    = true,
  $updates_repo_enabled = true,
) {

  anchor { 'straycat::os::pkgrepos::centos::start': }

  exec { 'yum-centos-repo-rm':
    command => 'rm /etc/yum.repos.d/CentOS-*.repo',
    path    => ['/bin', '/usr/bin'],
    unless  => 'test -z "$(ls /etc/yum.repos.d/CentOS-*.repo)"'
  }

  yumrepo { 'centos-base':
    descr          => "CentOS-${::centos_major}-${::architecture} Base",
    mirrorlist     => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra',
    failovermethod => 'priority',
    enabled        => $base_repo_enabled,
    gpgcheck       => 1,
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${::centos_major}",
    notify         => Straycat::Os::Pkgrepos::Repo_clean['centos-base'],
    require        => Exec['yum-centos-repo-rm']
  }

  yumrepo { 'centos-updates':
    descr          => "CentOS-${::centos_major}-${::architecture} Updates",
    mirrorlist     => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates&infra=$infra',
    failovermethod => 'priority',
    enabled        => $updates_repo_enabled,
    gpgcheck       => 1,
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${::centos_major}",
    notify         => Straycat::Os::Pkgrepos::Repo_clean['centos-base'],
    require        => Exec['yum-centos-repo-rm']
  }

  straycat::os::pkgrepos::repo_clean{ 'centos-base': }
  straycat::os::pkgrepos::repo_clean{ 'centos-updates': }

  straycat::os::pkgrepos::repo_makecache{ 'centos-base': }
  straycat::os::pkgrepos::repo_makecache{ 'centos-updates': }

  Straycat::Os::Pkgrepos::Repo_clean['centos-base']    ~> Straycat::Os::Pkgrepos::Repo_makecache['centos-base']
  Straycat::Os::Pkgrepos::Repo_clean['centos-updates'] ~> Straycat::Os::Pkgrepos::Repo_makecache['centos-updates']

  anchor { 'straycat::os::pkgrepos::centos::end':
    require => [Straycat::Os::Pkgrepos::Repo_clean['centos-base'],
                Straycat::Os::Pkgrepos::Repo_clean['centos-updates'],
                Straycat::Os::Pkgrepos::Repo_makecache['centos-base'],
                Straycat::Os::Pkgrepos::Repo_makecache['centos-updates']]
  }
}
