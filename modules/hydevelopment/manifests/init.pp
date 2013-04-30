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
                     ]


  
  package { $dependencies: ensure => installed }  

  file { "/home/${hyrise_user}/.tmux.conf":
        owner => $hyrise_user,
        group => $hyrise_user,
        mode => 644,
        source => 'puppet:///modules/hydevelopment/tmux.conf.erb'
 }

  vcsrepo { "/home/$hyrise_user/.oh-my-zsh":
      ensure => present,
      provider => git,
      source => 'https://github.com/robbyrussell/oh-my-zsh.git',
      user => $hyrise_user,
      require => User[$hyrise_user],
  }

  User <| title == $hyrise_user |> {
    shell => '/bin/zsh'
  } 
  
  exec { "ensureVagrantAuthKeys" :
   command => "bash -c 'echo 0'",
   onlyif => "bash -c 'test -f /home/vagrant/.ssh/authorized_keys' ",
   path => ["/bin/", "/sbin/"],
  }
  
  file { "/home/${hyrise_user}/.ssh":
    require => User[$hyrise_user],
    ensure => "directory",
  } -> file { "/home/$hyrise_user/.ssh/authorized_keys" :
    source => "/home/vagrant/.ssh/authorized_keys",
          owner => $hyrise_user,
          group => $hyrise_user,
          mode => 644,
          require => Exec['ensureVagrantAuthKeys'],
  }   

  file { "/home/${hyrise_user}/.zshrc":
          owner => $hyrise_user,
          group => $hyrise_user,
          mode => 644,
          source => 'puppet:///modules/hydevelopment/zshrc.erb',
          require => Vcsrepo["/home/$hyrise_user/.oh-my-zsh"]
  }

 vcsrepo { "/home/$hyrise_user/.scm_breeze":
    ensure => present,
    provider => git,
    source => 'git://github.com/ndbroadbent/scm_breeze.git',
    user => $hyrise_user,
    require => User[$hyrise_user]
 }

 exec { "install_scm_breeze":
	command => "/home/$hyrise_user/.scm_breeze/install.sh",
	onlyif => "/bin/grep -q scm_breeze.sh /home/$hyrise_user/.zshrc",
	require => Vcsrepo["/home/$hyrise_user/.scm_breeze"]
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


}
