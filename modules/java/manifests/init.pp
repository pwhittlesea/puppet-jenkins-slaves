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

}
