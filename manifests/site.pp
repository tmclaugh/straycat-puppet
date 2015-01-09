# Disable because we have Foreman
#import "nodes/*.pp"

# Just make stdlib available for use.  This also establishes our stages
# as well.  See stdlib::stages.
include stdlib

$exec_path = $::operatingsystem ? {
  centos => ["/bin", "/sbin", "/usr/bin", "/usr/sbin", "/usr/local/bin", "/usr/local/sbin", "/usr/kerberos/sbin", "/usr/kerberos/bin", "/usr/X11R6/bin", "/usr/X11R6/sbin"],
  default => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
}

Exec {
  path => $exec_path,
  logoutput => true
}
