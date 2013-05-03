class { 'hyrise':      
         ensure => 'present',
         mysql_password => 'hyrise',
}

class { 'hydevelopment':      
  hyrise_user => 'vagrant',
}
