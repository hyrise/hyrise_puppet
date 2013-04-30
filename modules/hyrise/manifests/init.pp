# Class: hyrise
#
# This module installs hyrise
#
# Parameters:
#   [*ensure*]
#     Ensure if present or absent.
#     Default: present
#
#   [*hyrise_user*]
#     Name of the Hyrise user
#     Default: hyrise
#
#   [*hyrise_dir*]
#     Directory to store Hyrise
#     Default: /hyrise
#
#   [*mysql_password*]
#     MySQL Password to set
#     Default: hyrise
#
# Actions:
#   Installs locales package and generates specified locales
#
# Requires:
#   Nothing
#
# Sample Usage:
#   class { 'sudo': }
#
# [Remember: No empty lines between comments and class definition]
class hyrise(
  $ensure = 'present',
  $hyrise_user = 'hyrise',
  $hyrise_dir = '~/hyrise',
  $mysql_password = 'hyrise',
) {

  case $ensure {
    /(present)/: {
      $dir_ensure = 'directory'
      $package_ensure = 'present'
      }
    /(absent)/: {
      $package_ensure = 'absent'
      $dir_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }


class { 'hyrise::packages': 
		hyrise_user => $hyrise_user,
		package_ensure => $package_ensure,
		dir_ensure => $dir_ensure,
		hyrise_dir => $hyrise_dir
}
class { 'hyrise::users': 
		hyrise_user => $hyrise_user,
		package_ensure => $package_ensure,
		dir_ensure => $dir_ensure,
		hyrise_dir => $hyrise_dir
}

class { 'mysql': }
class { 'mysql::server':
  config_hash => { 'root_password' => $mysql_password }
}

vcsrepo { "$hyrise_dir":
    ensure => present,
    provider => git,
    source => 'https://github.com/hyrise/hyrise.git',
    user => 'hyrise',
    require => User['hyrise']
}

}  
   
   
   
   
   
   
   
