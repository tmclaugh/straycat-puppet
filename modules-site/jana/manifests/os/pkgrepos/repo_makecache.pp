# == Define: jana::os::pkgrepos::repo_makecache
#
# Fetch a repo's metadata.
#
# === Parameters
#
# [*repo*]
#   Name of repo to clean.
#
# === Examples
#
# jana::os::pkgrepos::repo_makecache {'repo': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
define jana::os::pkgrepos::repo_makecache (
  $repo = $name
) {

  exec { "yum-makecache-${repo}":
    command     => "/usr/bin/yum --disablerepo=* --enablerepo=${repo} makecache",
    refreshonly => true
  }

}
