class git {

  case $operatingsystem {
    centos, redhat: { $git_package = "git" }
    debian, ubuntu: { $git_package = "git-core" }
    default: { fail("Unsupported OS") }
  }

  package {"git":
    name   => $git_package,
    ensure => latest
  }

}
