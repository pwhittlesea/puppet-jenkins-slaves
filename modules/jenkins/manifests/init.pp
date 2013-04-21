class jenkins (
  $user       = 'jenkins',
  $master     = 'buildmachine',
  $masterPort = '8080',
  $sshKey     = 'thekey'
) {

  add_user {"${user}":
    uid => 500
  }

  add_ssh_key {"${user}":
    key  => "${sshKey}",
    type => "ssh-rsa",
    name => "main"
  }

  file { "/home/${user}/bin":
    ensure  => "directory",
    owner   => "${user}",
    group   => "${user}",
    alias   => "jenkins-bin-folder",
    require => User["${user}"]
  }

  file { "/home/${user}/bin/launch-slave":
    owner   => "${user}",
    group   => "${user}",
    mode    => "0755",
    content => template("jenkins/launch-slave.erb"),
	require => File["jenkins-bin-folder"]
  }

  file { "/home/${user}/bin/watchdog":
    owner   => "${user}",
    group   => "${user}",
    mode    => "0755",
	alias   => "watchdog-file",
    content => template("jenkins/watchdog.erb"),
	require => File["jenkins-bin-folder"]
  }
  
  cron { "slave-watchdog":
    command => "/home/${user}/bin/watchdog",
    user    => "${user}",
    minute  => '*/5',
	require => File["watchdog-file"]
  }
}
