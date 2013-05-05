import "classes/*.pp"

node 'slave1' {
  slave { "master":
    user => "user1"
  }
}

node 'slave2' {
  slave { "master":
    user => "user2"
  }
}
