class { 'hyrise':      
         ensure => 'present',
         hyrise_user => 'hyrise',
         hyrise_dir => "/home/hyrise/hyrise",
         mysql_password => 'hyrise',
         #require => Mount['/hyrise']
}

class { 'hydevelopment':      
  hyrise_user => 'hyrise',
}
