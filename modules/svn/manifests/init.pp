# == Class: svn
#
# This class installs Subversion.
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
#   class { 'svn': }
#
# === Authors
#
# Phillip Whittlesea <pw.github@thega.me.uk>
#
# === Copyright
#
# Copyright 2013 Phillip Whittlesea, unless otherwise noted.
#
class svn {

  package {"svn":
    name   => "subversion",
    ensure => latest
  }

}
