class hyrise::users ($hyrise_user, $package_ensure, $dir_ensure, $hyrise_dir) {

  group { $hyrise_user:
          ensure => present
  }

  $hash = sha1($hyrise_user)

  user { $hyrise_user:
    ensure            =>  'present',
    gid               =>  $hyrise_user,
    home              =>  "/home/${hyrise_user}",
    comment           =>  'Hyrise Service',
    managehome        =>  true,
    password          =>  "\$6\$${hash}",
    require           =>  [ Group[$hyrise_user] ] 
  }
  
}
