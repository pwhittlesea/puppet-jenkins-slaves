# == Class: hosts
#
# This class updates the hosts file of the machine.
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
# class { 'hosts': }
#
# === Authors
#
# Phillip Whittlesea <pw.github@thega.me.uk>
#
# === Copyright
#
# Copyright 2013 Phillip Whittlesea, unless otherwise noted.
#
class hosts {

  file { '/etc/hosts':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("hosts/hosts.erb"),
  }

}
