# == Define: slave
#
# Full description of defined resource type example_resource here.
#
# === Parameters
#
# $master:: The hostname of the machine that this slave will connect to.
#
# $user:: The user this slave will use to run the Jenkins scripts.
#
# $port:: The port of the machine that this slave will connect to.
#
# === Examples
#
# slave { "master":
#   user => "user1"
# }
#
# === Authors
#
# Phillip Whittlesea <pw.github@thega.me.uk>
#
# === Copyright
#
# Copyright 2013 Phillip Whittlesea, unless otherwise noted.
#
define slave (
  $master = $title,
  $user   = 'jenkins',
  $port   = '8080'
) {

  class {"jenkins":
    user       => $user,
    master     => $master,
    masterPort => $port
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
