# == Class: development
#
# Full description of class development here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { development:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class hydevelopment($hyrise_user) {
    $dependencies = [
                     "sphinx-common",
                     "emacs",
                     "gdb",
                     "valgrind",
                     "tmux",
                     "zsh",
                     "software-properties-common",
                     "clang-3.2",
                     "libclang-dev"
                     ]

  package { $dependencies: ensure => installed }  

  file { "/home/${hyrise_user}/.tmux.conf":
        owner => $hyrise_user,
        group => $hyrise_user,
        mode => 644,
        source => 'puppet:///modules/hydevelopment/tmux.conf.erb'
 }

 Package["software-properties-common"] -> exec { "enable repository ppa:ubuntu-toolchain-r/test":
   command => 'add-apt-repository ppa:ubuntu-toolchain-r/test -y && touch /root/.addedppa && apt-get update',
   path => '/bin/:/sbin/:/usr/bin/:/usr/local/bin/',
   creates => '/root/.addedppa',
 } -> package { ["gcc-4.8", "g++-4.8"] : ensure => installed }

  vcsrepo { "/home/$hyrise_user/.oh-my-zsh":
      ensure => present,
      provider => git,
      source => 'https://github.com/robbyrussell/oh-my-zsh.git',
      user => $hyrise_user,
      require => User[$hyrise_user],
  }

  User <| title == $hyrise_user |> {
    
  } 
  

  file { "/home/${hyrise_user}/.zshrc":
          owner => $hyrise_user,
          group => $hyrise_user,
          mode => 644,
          source => 'puppet:///modules/hydevelopment/zshrc.erb',
          require => [Vcsrepo["/home/$hyrise_user/.oh-my-zsh"], Package["zsh"]],
          replace => false,
  }

 vcsrepo { "/home/$hyrise_user/.scm_breeze":
    ensure => present,
    provider => git,
    source => 'git://github.com/ndbroadbent/scm_breeze.git',
    user => $hyrise_user,
    require => User[$hyrise_user],
 }

 exec { "install_scm_breeze":
	command => "/bin/su - $hyrise_user /home/$hyrise_user/.scm_breeze/install.sh",
	unless => "/bin/grep -q scm_breeze.sh /home/$hyrise_user/.zshrc",
#        user => $hyrise_user,
#        group => $hyrise_user,
         logoutput => 'true',    
	require => [Vcsrepo["/home/$hyrise_user/.scm_breeze"], File["/home/$hyrise_user/.zshrc"]]
}            

exec { "install_cpanm":
	command => "/usr/bin/curl -L http://cpanmin.us | perl - App::cpanminus",
	cwd => "/root",
	user => "root",
	creates => "/usr/local/bin/cpanm",
        require => Package["curl"]
} 
exec { "install_cpanm_modules":
	command => "/usr/local/bin/cpanm Term::ANSIColor Getopt::ArgvFile Getopt::Long Regexp::Common && touch /var/local/install_cpanm_modules",
	cwd => "/root",
	user => "root",
	creates => "/var/local/install_cpanm_modules",
        require => Exec["install_cpanm"],
}

group { $hyrise_user:
          ensure => present
}

user { $hyrise_user:
    ensure            =>  present,
    gid               =>  $hyrise_user,
    home              =>  "/home/${hyrise_user}",
    comment           =>  'Hyrise Development User',
    managehome        =>  true,
    require           =>  [ Group[$hyrise_user], Package["zsh"] ],
    shell => '/bin/zsh',
}

vcsrepo { "/home/$hyrise_user/hyrise":
    ensure => present,
    force => true,
    provider => git,
    source => 'https://github.com/hyrise/hyrise.git',
    user => $hyrise_user,
    require => Package['git'],
}



}
