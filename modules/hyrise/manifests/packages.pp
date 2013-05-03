class hyrise::packages ($package_ensure) {

    $dependencies = [ 	
                     "curl",
                     "bzip2",
                     "ccache",
                     "cmake",
                     "git",
                     "liblog4cxx10",
                     "liblog4cxx10-dev",
                     "libmysqlclient-dev",
                     "libnuma-dev",
                     "libunwind8-dev",
                     "libunwind8",
                     "libev-dev",
                     "libboost-all-dev",
                     "binutils-dev",
                     "libgoogle-perftools-dev"
                    ]

package { $dependencies: ensure => $package_ensure }


hyrise::netinstall { 'libcsv-3.0.1':
  url => 'http://downloads.sourceforge.net/project/libcsv/libcsv/libcsv-3.0.1/libcsv-3.0.1.tar.gz',
  extracted_dir => 'libcsv-3.0.1',
  postextract_command => 'make install',
  require => Package[$dependencies],
  creates => "/usr/lib/libcsv.so"
}

hyrise::netinstall { 'metis-5.0.2':
  url => 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.0.2.tar.gz',
  extracted_dir => 'metis-5.0.2',
  postextract_command => 'make config && make install',
  require => Package[$dependencies],
  creates => "/usr/local/lib/libmetis.a"
}

hyrise::netinstall { 'hwloc-1.6':
  url => 'http://www.open-mpi.org/software/hwloc/v1.6/downloads/hwloc-1.6.tar.gz',
  extracted_dir => 'hwloc-1.6',
  postextract_command => 'configure && make && make install',
  require => Package[$dependencies],
  creates => "/usr/local/bin/hwloc-info"
}

hyrise::netinstall { 'papi-5.0.1':
  url => 'http://icl.cs.utk.edu/projects/papi/downloads/papi-5.0.1.tar.gz',
  extracted_dir => 'papi-5.0.1',
  working_dir_ext => 'src/',
  postextract_command => 'configure && make && make install',
  require => Package[$dependencies],
  creates => "/usr/local/bin/papi_version" 
}

}
