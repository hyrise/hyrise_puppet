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

class hyrise(
  $ensure = 'present',
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


class { 'hyrise::packages': package_ensure => $package_ensure, }

class { 'mysql': }
class { 'mysql::server':
  config_hash => { 'root_password' => $mysql_password }
}


}  
   
   
   
   
   
   
   
