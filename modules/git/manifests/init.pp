# == Class: git
#
# This class installs Git.
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
#  class {'java': }
#
# === Authors
#
# Phillip Whittlesea <pw.github@thega.me.uk>
#
# === Copyright
#
# Copyright 2013 Phillip Whittlesea, unless otherwise noted.
#
class git {

  case $operatingsystem {
    centos, redhat: { $git_package = "git" }
    debian, ubuntu: { $git_package = "git-core" }
    default: { fail("Unsupported OS") }
  }

  package { "git":
    name   => $git_package,
    ensure => latest
  }

}
