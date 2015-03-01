# apply requested role or use our default.  This is not secure.  Only meant
# to be used when setting up a new environment.

node default {

  if $::role {
    class { $role: }
  } else {
    class { '::jana::roles::base': }
  }
}
