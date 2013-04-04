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
  user { "tomcat":
    ensure     => 'present',
    home       => '/home/tomcat',
    shell      => '/bin/bash',
    managehome => true,
    before     => File['release'],
  }

  exec {"untar_folder":
    user     => 'tomcat',
    command   => "tar -xvf /etc/puppetlabs/puppet/modules/tomcat/files/base-tomcat.tar",
    logoutput => true,
    before    => File['directory'],  
    refreshonly => true,
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
    path    => "${server}/bin/catalina.sh",
    content => template('tomcat/catalina.sh'),
  }
  file { "server.xml" :
    ensure  => present, 
    path    => "${server}/conf/server.xml",
    content => template('tomcat/server.xml'),
  }

  file { 'release':
    ensure  => [ [ 'directory'],['present']],
    path    => '/home/tomcat/release',
    owner   => 'tomcat',
    mode    => '0640',
    before  => File['startServer.sh'],
  }

  file { 'startServer.sh':
    ensure  => present,
    require => User['tomcat'],
    content => 'puppet:///modules/tomcat/startServer.sh',
    path    => '/home/tomcat/release/startServer.sh',
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0640', 
  }
  file { 'stopServer.sh':
    ensure  =>  present,
    require => User['tomcat'],
    content => 'puppet:///modules/tomcat/stopServer.sh',
    path    => '/home/tomcat/release/stopServer.sh',
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0640',
  }
  file { 'restartServer.sh':
    ensure  =>  present,
    require =>  User['tomcat'],
    content => 'puppet:///modules/tomcat/restartServer.sh',
    path    => '/home/tomcat/release/restartServer.sh',
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0640',
  }

  file { 'component-deploy.sh':
    ensure =>   present,
    require =>  User['tomcat'],
    content => 'puppet:///modules/tomcat/component-deploy.sh',
    path   => '/home/tomcat/release/component-deploy.sh',
    owner  => 'tomcat',
    group  => 'tomcat',
    mode => '0640',
  }

  file { 'component-war-deploy.sh':
    ensure           =>  present,
    require        =>  User['tomcat'],
    content      => 'puppet:///modules/tomcat/component-war-deploy.sh',
    path       => '/home/tomcat/release/component-war-deploy.sh',
    owner    => 'tomcat',
    group  => 'tomcat',
    mode => '0640',
  }


file { 'static-deploy.sh':
    ensure           =>  present,
      require        =>  User['tomcat'],
        content      => 'puppet:///modules/tomcat/static-deploy.sh',
          path       => '/home/tomcat/release/static-deploy.sh',
            owner    => 'tomcat',
              group  => 'tomcat',
                mode => '0640',
                 }


}

