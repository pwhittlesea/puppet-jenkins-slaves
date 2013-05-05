# == Class: jenkins
#
# This class creates a user to execute the Jenkins jnlp.
# Installs a watchdog cron job and script to automatically start the jnlp.
#
# === Parameters:
#
# $user::       The username that will run the slave client.
#
# $master::     The hostname of the Jenkins master.
#
# $masterPort:: The port of the Jenkins master.
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
#   class {'jenkins':
#     user       => 'buildadmin',
#     master     => 'buildmachine',
#     masterport => '8080'
#   }
#
# === Authors
#
# Phillip Whittlesea <pw.github@thega.me.uk>
#
# === Copyright
#
# Copyright 2013 Phillip Whittlesea, unless otherwise noted.
#
class jenkins (
  $user       = 'jenkins',
  $master     = 'buildmachine',
  $masterPort = '8080'
) {

  add_user { $user:
    uid => 500
  }

  file { "/home/${user}/bin":
    ensure  => "directory",
    owner   => $user,
    group   => $user,
    alias   => "jenkins-bin-folder",
    require => User[$user]
  }

  file { "/home/${user}/bin/launch-slave":
    owner   => $user,
    group   => $user,
    mode    => "0755",
    content => template("jenkins/launch-slave.erb"),
	require => File["jenkins-bin-folder"]
  }

  file { "/home/${user}/bin/watchdog":
    owner   => $user,
    group   => $user,
    mode    => "0755",
	alias   => "watchdog-file",
    content => template("jenkins/watchdog.erb"),
	require => File["jenkins-bin-folder"]
  }

  cron { "slave-watchdog":
    command => "/home/${user}/bin/watchdog",
    user    => $user,
    minute  => '*/5',
	require => File["watchdog-file"]
  }

  file { "/opt/jenkins":
    ensure  => "directory",
    owner   => $user,
    group   => $user,
    alias   => "jenkins-folder",
    require => User[$user]
  }

  file { "/opt/jenkins/.m2":
    ensure  => "directory",
    owner   => $user,
    group   => $user,
    alias   => "jenkins-m2",
    require => File["jenkins-folder"]
  }

  file { "/home/${user}/.m2":
    ensure  => "link",
    target  => "/opt/jenkins/.m2",
    require => File["jenkins-m2"]
  }

}
