# == Class: maven
#
# This class installs Apache Maven into /opt/maven.
# Executables will be sym-linked in /bin/mvn
#
# === Parameters:
#
# $version:: The version of Maven to install.
#
# === Requires:
#
# The Apache Maven compressed binaries need to be downloaded and placed in
# puppet:///modules/maven/ with the name format apache-maven-${version}-bin.zip
#
# === Sample Usage:
#
#   class {'maven':
#     version => '2.2.1',
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
class maven (
  $version      = '2.2.1'
) {

  package {"unzip":
    ensure => latest
  }

  $mvn_base = $::hostname ? {
    default => "/opt/maven",
  }

  file { $mvn_base:
    ensure => "directory",
    owner  => "root",
    group  => "root",
    alias  => "mvn-folder"
  }

  file { "${mvn_base}/apache-maven-${version}-bin.zip":
    mode    => 0744,
    owner   => "root",
    group   => "root",
    alias   => "mvn-exe",
    source  => "puppet:///modules/maven/apache-maven-${version}-bin.zip",
    before  => Exec["mvn-extract"],
    require => File["mvn-folder"]
  }

  exec { "unzip -fo apache-maven-${version}-bin.zip":
    command     => "/usr/bin/unzip -fo apache-maven-${version}-bin.zip",
    cwd         => "${mvn_base}",
    creates     => "${mvn_base}/apache-maven-${version}/",
    alias       => "mvn-extract",
    refreshonly => true,
    subscribe   => File["mvn-exe"]
  }

  $mvn_dirs = [
    "${mvn_base}/apache-maven-${version}/",
    "${mvn_base}/apache-maven-${version}/bin/",
    "${mvn_base}/apache-maven-${version}/boot/",
    "${mvn_base}/apache-maven-${version}/conf/",
    "${mvn_base}/apache-maven-${version}/lib/"
  ]

  file { $mvn_dirs:
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    mode    => 0555,
    require => File["mvn-folder"]
  }

  file { "${mvn_base}/apache-maven-${version}/conf/settings.xml":
    owner => "root",
    group => "root",
    mode  => 0555,
    source  => "puppet:///modules/maven/settings.xml",
    require => File["${mvn_base}/apache-maven-${version}/conf"]
  }

  file { '/bin/mvn':
    ensure  => "link",
    target  => "${mvn_base}/apache-maven-${version}/bin/mvn",
    require => File["${mvn_base}/apache-maven-${version}/bin/"]
  }

}
