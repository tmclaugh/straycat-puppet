class straycat::os::pkgrepos::epel (
  $enabled    = true,
) {

  anchor { 'straycat::os::pkgrepos::epel::start': }

  if $enabled == true {
    $repo_enabled = '1'
  } else {
    $repo_enabled = '0'
  }

  yumrepo { 'epel':
    descr           => "Extra Packages for Enterprise Linux ${::centos_major} - ${::architecture}",
    baseurl         => "http://download.fedoraproject.org/pub/epel/\$releasever/\$basearch",
    #mirrorlist      => 'https://mirrors.fedoraproject.org/metalink?repo=epel-$releasever&arch=$basearch',
    failovermethod  => 'priority',
    enabled         => $repo_enabled,
    gpgcheck        => 1,
    gpgkey          => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${::centos_major}",
    notify          => Straycat::Os::Pkgrepos::Repo_clean['epel']
  }

  straycat::os::pkgrepos::repo_clean{ 'epel': }

  anchor { 'straycat::os::pkgrepos::epel::end':
    require => [Anchor['straycat::os::pkgrepos::epel::start'],
                Straycat::Os::Pkgrepos::Repo_clean['epel']]
  }

}
