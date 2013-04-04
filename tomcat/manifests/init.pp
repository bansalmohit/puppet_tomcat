class tomcat($tomcat_port= 76 , $component=catalog-tomcat,){
  $server = "/usr/local/${component}"


  package { "java-1.6.0-openjdk.i386":
    ensure  => [ ['installed'],['latest']],
  }

  Exec {
    path => [
      '/usr/local/bin',
      '/opt/local/bin',
      '/usr/bin',
      '/usr/sbin',
      '/bin',
      '/sbin'],
      logoutput => true,
  }

    file { 'directory':
      name    => "${component}",
      path    => "${server}",
    recurse   => true,
    ensure    => [ ['directory'] , ['present']],
      before  => [ File[ ['catalina.sh'] , ['server.xml']]],
      owner   => 'tomcat',
      group   => 'tomcat',
      mode    => '0640',
     source => 'puppet:///modules/tomcat/usr/local/base-tomcat7/',
  
    }

    file { "catalina.sh":
      ensure  => present,
      require => File['bin'],
      path    => "${server}/bin/catalina.sh",
      content => template('tomcat/catalina.sh'),
    }
    file { "server.xml" :
      ensure  => present, 
      require => File['conf'],
      path    => "${server}/conf/server.xml",
      content => template('tomcat/server.xml'),
    }
  }


