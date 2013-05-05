# == Class: java
#
# This class installs Oracle Java into /opt/java.
# Executables will be sym-linked in /bin/java and /bin/javac
#
# === Parameters:
#
# $distribution:: jdk or jre.
#
# $version:: The version of Java to install.
#
# === Requires:
#
# The Oracle Java compressed binaries need to be downloaded and placed in
# puppet:///modules/java/ with the name format ${distribution}-${version}-linux-${java_platform}.bin
#
# === Sample Usage:
#
#   class {'java':
#     distribution => 'jre',
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
class java (
  $distribution = 'jdk',
  $version      = '1.6.0_43'
) {

  $java_platform = $::hostname ? {
    default => "x64",
  }

  $java_base = $::hostname ? {
    default => "/opt/java",
  }

  file { "${java_base}":
    ensure => "directory",
    owner  => "root",
    group  => "root",
    alias  => "java-folder"
  }

  file { "${java_base}/${distribution}-${version}-linux-${java_platform}.bin":
    mode    => 0744,
    owner   => "root",
    group   => "root",
    alias   => "java-exe",
    source  => "puppet:///modules/java/${distribution}-${version}-linux-${java_platform}.bin",
    before  => Exec["java-extract"],
    require => File["java-folder"]
  }

  exec { "sh ${distribution}-${version}-linux-${java_platform}.bin -noregister":
    command     => "/bin/sh ${distribution}-${version}-linux-${java_platform}.bin -noregister",
    cwd         => "${java_base}",
    creates     => "${java_base}/${distribution}${version}/",
    alias       => "java-extract",
    refreshonly => true,
    subscribe   => File["java-exe"]
  }

  file { '/bin/java':
    ensure  => "link",
    target  => "${java_base}/${distribution}${version}/bin/java",
    require => File["java-folder"]
  }

  file { '/bin/javac':
    ensure  => "link",
    target  => "${java_base}/${distribution}${version}/bin/javac",
    require => File["java-folder"]
  }

}
