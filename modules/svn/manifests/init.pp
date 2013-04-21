class svn {

  package {"svn":
    name   => "subversion",
    ensure => latest
  }

}
