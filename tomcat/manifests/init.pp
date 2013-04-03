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

  # exec {"untar_folder":
    # user      => 'tomcat',
    #command   => "tar -xvf ${server}/base-tomcat.tar",
    #logoutput => true,
    
    # refreshonly => true,
    #}
    file { 'directory':
      name    => "${component}",
      path    => "${server}",
    recurse   => true,
    ensure    => [ ['directory'] , ['present']],
      before  => [ File[ ['catalina.sh'] , ['server.xml']]],#Exec['untar_folder'] ],
      owner   => 'tomcat',
      group   => 'tomcat',
      mode    => '0640',
     source => 'puppet:///modules/tomcat/usr/local/base-tomcat7/',
  
    }


    #file { "root.xml":
    #ensure => present,
    #path    => "${server}/conf/Catalina/localhost/",
    #name   => "ROOT.xml",
    #content => template('tomcat5/root_template.erb'),

    #  }

    file {'bin':
      path   => "${server}/bin",
      owner  => 'tomcat',
      group  => 'tomcat',
      mode   => '0640',
      ensure => 'directory',
    }

    file {'conf':
      path                           => "${server}/conf",
      owner                    => 'tomcat',
      group              => 'tomcat',
      mode         => '0640',
      ensure => 'directory',
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


