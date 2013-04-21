define add_user (
  $uid
) {

 $username = $title

  user {$username:
    comment => "Generated via Puppet",
    home    => "/home/${username}",
    uid     => $uid
  }

  group {$username:
    gid     => $uid,
    require => User[$username]
  }

  file {"/home/${username}/":
    ensure  => directory,
    owner   => $username,
    group   => $username,
    require => [User[$username],Group[$username]]
  }

  file {"/home/${username}/.ssh/":
    ensure  => directory,
    owner   => $username,
    group   => $username,
    mode    => 700,
    require => File["/home/${username}/"]
  }

  file {"/home/${username}/.ssh/authorized_keys":
    ensure  => present,
    owner   => $username,
    group   => $username,
    mode    => 600,
    require => File["/home/${username}/.ssh/"]
  }

}

define add_ssh_key (
  $key,
  $type,
  $name
) {

  $username = $title

  ssh_authorized_key {$name:
    ensure => present,
    key    => $key,
    type   => $type,
    user   => $username,
    require => File["/home/${username}/.ssh/authorized_keys"]
  }
  
}
