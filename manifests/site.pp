import "classes/*.pp"

node 'slave1' {
  class { "slave": }
}

class slave (
  $user = "jenkins"
) {

  class {"jenkins":
    user       => "${user}",
    master     => 'jenkins',
    masterPort => '8080'
  }

  class {"git": }

  class {"hosts": }

  class {"java": }

  class {"maven": }

  class {"ntp":
    enable => true,
    ensure => running
  }

  class {"svn": }

}
