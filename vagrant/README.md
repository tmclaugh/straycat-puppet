Vagrant
===
[Vagrant](http://www.vagrantup.com/) provides a wrapper around [VirtualBox](https://www.virtualbox.org/) to quickly spin up and destroy VMs (guests) on the desktop (host).  It includes several provisioner plugins including Puppet provisioners that will apply Puppet manifests to the VM or have it talked to a puppetmaster.  The TechOps team provides a Vagrant _.box_ for use that is in line with the latest stable AWS image.  It varies slightly but not by much and provides useful platform for quickly testing changes.  There is no need to retrieve the guest image beforehand as Vagrant will retrieve it if it does not exist.

Our standard Vagrant box image will setup a puppetmaster under _/etc/puppetmaster_ and will mount the local puppet repository from the host to _/etc/puppet-local_ in the Vagrant instance.  Once the Puppetmaster is setup Vagrant will have the instance run `puppet agent` against its newly setup puppetmaster and apply by default _straycat::roles::base_.  The whole process (provided the Vagrant box has already been downloaded takes only a few minutes.  Once the role class has finished applying the image can be SSHed into.  Changes can then be made from host development environment and tested immediately in the Vagrant instance by running _sudo puppet agent -t_

Rakefile usage
---
Our Vagrant setup is meant to be driven by Rakefile in the [_vagrant/_](https://github.com/tmclaugh/straycat-puppet/new/blob/production/vagrant/Vagrantfile) directory.  The wrapper was created to help mimic a deployment from Rainmaker and to provide greater flexibility in usage.  The Rakefile method wraps most standard Vagrant commands.

<pre>
[tmclaughlin@tomcat vagrant]$ rake --tasks
rake vagrant:change_branch[branch]                 # switch to correct branch
rake vagrant:compile[instance,host]                # Bring up instance and then destroy it.
rake vagrant:destroy[instance,host]                # Destroy instance
rake vagrant:global                                # Get status of all Vagrant environments
rake vagrant:halt[instance,host]                   # Halt instance
rake vagrant:init[instance]                        # initialize instance
rake vagrant:provision[instance,host,provisioner]  # Run the provisioner again
rake vagrant:reload[instance,host]                 # Reload instance
rake vagrant:remove[instance]                      # Remove instance entirely
rake vagrant:resume[instance,host]                 # Resume instance
rake vagrant:run_librarian[branch]                 # run librarian-puppet
rake vagrant:ssh[instance,host]                    # SSH into instance
rake vagrant:status[instance,host]                 # Check instance status
rake vagrant:suspend[instance,host]                # Suspend instance
rake vagrant:up[instance,host]                     # Bring up instance
</pre>

The Rakefile wrapper provides:
* The ability to associate a git branch with an instance
  * Each time the instance is started the wrapper will change the git to that branch.
* The ability to associate a default role with an instance that is persistent.
  * Each time the instance is started that default role will be used.
* Task dependencies
  * It will ensure puppet-lint has been run before starting a new instance.
  * If there is a branch associated with the instance it will ensure librarian-puppet was run against that branch.
* The ability to use multiple instances at once.
  * NOTE: instances do not yet know when the host's Puppet tree has changed branches.

## Starting an instance
The following command will setup a new instance of the given name (_test-instance_).  It will only setup the instance and not start a guest.  By default every time the instance is spun up it will have "straycat::role::base" and the wrapper will not perform any Git branch checking.

<pre>
[tmclaughlin@tomcat vagrant]$ rake vagrant:init[test-instance]
Creating /Users/tmclaughlin/Source/tmclaughlin_puppet-deploy/vagrant/instance/test-instance
/Users/tmclaughlin/Source/tmclaughlin_puppet-deploy/vagrant/instance/test-instance
vagrant init
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
Starting instance with:
role:   base
branch:
</pre>


Starting the instance is doen with the _up_ task.

<pre>
[tmclaughlin@tomcat vagrant]$ rake vagrant:up[test-instance]
vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
[default] Box 'CentOS-6.5-x86_64-201312301757' was not found. Fetching box from specified URL for
the provider 'virtualbox'. Note that if the URL does not have
a box for this provider, you should interrupt Vagrant now and add
the box yourself. Otherwise Vagrant will attempt to download the
full box prior to discovering this error.
Extracting box...
Successfully added box 'CentOS-6.5-x86_64-201312301757' with provider 'virtualbox'!
[default] Importing base box 'CentOS-6.5-x86_64-201312301757'...
[default] Matching MAC address for NAT networking...
[default] Setting the name of the VM...
[default] Clearing any previously set forwarded ports...
[default] Clearing any previously set network interfaces...
[default] Preparing network interfaces based on configuration...
[default] Forwarding ports...
[default] -- 22 => 2222 (adapter 1)
[default] Running 'pre-boot' VM customizations...
[default] Booting VM...
[default] Waiting for machine to boot. This may take a few minutes...
[default] Machine booted and ready!
[default] Setting hostname...
[default] Mounting shared folders...
[default] -- /vagrant
[default] -- /etc/puppet-local
[default] Running provisioner: puppet...
Running Puppet with vagrant.pp...
Notice: /Stage[main]//File[/var/lib/puppet/concat]/ensure: created
Notice: /Stage[main]//Package[puppet-server]/ensure: created
Notice: /Stage[main]//File[/etc/sysconfig/puppetmaster]/content: content changed '{md5}5dcd27339b7ae8cfa0c7f226662b6910' to '{md5}2a255b96995f30e89328e2b716f46010'
Notice: /Stage[main]//File[/etc/puppet/environments]/ensure: created
Notice: /Stage[main]//File[/etc/puppet/environments/production]/ensure: created
Notice: /Stage[main]//File[/etc/puppetmaster]/ensure: created
Notice: /Stage[main]//File[/etc/puppetmaster/manifests]/ensure: created
Notice: /Stage[main]//File[/etc/puppetmaster/manifests/site.pp]/ensure: created
Notice: /Stage[main]//File[/etc/puppetmaster/puppet-vagrant.conf]/ensure: created
Notice: /Stage[main]//File[/etc/puppet/environments/production/live]/ensure: created
Notice: /Stage[main]//File[/etc/puppetmaster/autosign.conf]/ensure: created
Notice: /Stage[main]//Service[puppetmaster]/ensure: ensure changed 'stopped' to 'running'
Notice: /Stage[main]//File[/etc/puppetmaster/var/concat]/ensure: created
Notice: Finished catalog run in 26.20 seconds
[default] Running provisioner: puppet_server...
[default] Running Puppet agent...
...
(At this point the host will talk to its Puppetmaster and apply the default role class)
...
</pre>


If the defaults are not suitable pass the branch and/or role arguments.  (The role argument should not have the leading _straycat::roles::_ portion of the class name.)

<pre>
[tmclaughlin@tomcat vagrant]$ rake vagrant:init[test-instance] branch=pgsql_ver role=postgresql.
Creating /Users/tmclaughlin/Source/tmclaughlin_puppet-deploy/vagrant/instance/test-instance
/Users/tmclaughlin/Source/tmclaughlin_puppet-deploy/vagrant/instance/test-instance
vagrant init
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
Starting instance with:
role:   postgresql
branch: pgsql_ver
</pre>


When starting a new instance without role or branch arguments the instance will use the defaults passed to the init task.

<pre>
[tmclaughlin@tomcat vagrant]$ rake vagrant:up[test-instance]
checking defaults
Starting instance with:
role:   postgresql
branch: pgsql_ver
vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
</pre>


The defaults can always be overridden on a one-time basis when starting a new instance.

<pre>
[tmclaughlin@tomcat vagrant]$ rake vagrant:up[test-instance] branch=phppgadmin_update role=phppgadmin
checking defaults
Starting instance with:
role:   phppgadmin
branch: phppgadmin_update
vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
</pre>

### Profiles
Some situations are more complex than the standard setup.  These include multi-machine setups, requirements to override default values, roles that require values from an ENC, etc.  For those situations profiles can be added to the _profiles_ directory.  Create a subdirectory and add either or both of the following depending on what you are trying to achieve.

* config.rb
  * Define machines
  * Override provisioners
* vars.rb
  * Overrides global variables in [_Vagrantfile_](https://github.com/tmclaugh/straycat-puppet/blob/production/vagrant/Vagrantfile)

<pre>
[tmclaughlin@tomcat vagrant]$ rake vagrant:up[ipa] profile=ipa-env
Checking instance defaults
Checking instance defaults
Checking for plugin: vagrant-vbguest
vagrant plugin list | grep vagrant-vbguest
vagrant-vbguest (0.10.0)
Checking for plugin: vagrant-hostmanager
vagrant plugin list | grep vagrant-hostmanager
vagrant-hostmanager (1.5.0)


Starting instance with:
role:           base
branch:         false
profile:        ipa-env
</pre>

## Interacting with an instance

After the host has finished provisioning SSH into the host

<pre>
[tmclaughlin@tomcat vagrant]$ rake vagrant:ssh[test-instance]
Welcome to vagrant.straycat.local.

[vagrant@vagrant ~]$
</pre>


To test changes, edit files in the development environment on the host and run _puppet agent_ on the guest instance

<pre>
[vagrant@vagrant ~]$ sudo puppet agent -t
Info: Retrieving plugin
...
</pre>

## Destroying an instance
Once done testing either the running instance can be destroyed or the entire configuration can be removed.  A particular set of work may be completed and the running VM is no longer needed but there's still more work to be done another day.  In that case the running instance can be destroyed.

<pre>
[tmclaughlin@tomcat vagrant]$ rake vagrant:destroy[test-instance]
vagrant destroy -f
[default] Forcing shutdown of VM...
[default] Destroying VM and associated drives...
[default] Running cleanup tasks for 'puppet' provisioner...
[default] Running cleanup tasks for 'puppet_server' provisioner...
</pre>


If an entire body of work is finished and the configured instance is no longer necessary, perhaps a PR has been submitted and merged, the instance can be fully removed.

<pre>
[tmclaughlin@tomcat vagrant]$ rake vagrant:remove[test-instance]
vagrant destroy -f
[default] VM not created. Moving on...
</pre>


The Rakefile method provides analogous tasks for most Vagrant commands.  (It does not handle Vagrant box or plugin management.)  It also provides a compile task that some may find convenient.  This task calls the up task and immediately destroys the instance if it instantiates and runs puppet successfully.  This is a convenience task for doing an end to end test of a change.  Testing a set of changes from end to end as a last step is necessary.  It is not uncommon for an existing host to accept a change without error but do to a lack of proper dependency ordering have a newly condensed host fail.

<pre>
[tmclaughlin@tomcat vagrant]$ rake vagrant:compile[test-instance]
checking defaults
Starting instance with:
role:   role_basenode
branch:
vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
...
vagrant destroy -f
[default] Forcing shutdown of VM...
[default] Destroying VM and associated drives...
[default] Running cleanup tasks for 'puppet' provisioner...
[default] Running cleanup tasks for 'puppet_server' provisioner...
</pre>
