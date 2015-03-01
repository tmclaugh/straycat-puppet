# == Define: jana::os::pkgrepos::repo_clean
#
# Clean a repo's metadata.
#
# === Parameters
#
# [*repo*]
#   Name of repo to clean.
#
# === Examples
#
# jana::os::pkgrepos::repo_clean {'foo': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
define jana::os::pkgrepos::repo_clean (
  $repo = $name
) {

  exec { "yum-clean-${repo}":
    command     => "/usr/bin/yum --disablerepo=* --enablerepo=${repo} clean all",
    refreshonly => true
  }

}
