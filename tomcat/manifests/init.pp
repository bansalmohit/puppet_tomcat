class tomcat($tomcat_port= 8080, $component=tomcat,){
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
    before     => File['release-dir'],
  }

  file{ 'copy-tomcat':
      name    => 'base-tomcat.tar',
      path    => '/home/tomcat/base-tomcat.tar',
      recurse => true,
      source  => 'puppet:///modules/tomcat/base-tomcat.tar',
      owner   => 'tomcat',
      mode    => '0640',
  }


  exec {"extract-tomcat":
    user        => 'tomcat',
    command     => "tar -xvf /home/tomcat/base-tomcat.tar",
    refreshonly => true,
    require     => File['copy-tomcat'],
  }

  file { 'component-directory':
    name    => "${component}",
    path    => "${server}",
    recurse   => true,
    ensure    => [ ['directory'] , ['present']],
       owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0640',
   source => "/home/tomcat/base-tomcat/",
    
  }
    file { "catalina.sh":
    ensure => present,
   path    => "${server}/bin/catalina.sh",
   content => template('tomcat/catalina.sh'),
  require  => File['component-directory'],
    }
  file { "server.xml" :
   ensure  => present, 
   path    => "${server}/conf/server.xml",
   content => template('tomcat/server.xml'),
   require => File['component-directory'],
  }

  file { 'release-dir':
    name   => 'release',
    ensure => [ [ 'directory'],['present']],
    path   => '/home/tomcat/release',
    owner  => 'tomcat',
    mode   => '0640',
  }

  file { 'scriptDir':
    ensure  => [['present'],['directory']],
    require => [ [User['tomcat']],[File['release-dir']]],
    recurse => true,
    content => 'puppet:///modules/tomcat/scriptDir/',
    path    => '/home/tomcat/release/scriptDir/',
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0640', 
 
  }


}

