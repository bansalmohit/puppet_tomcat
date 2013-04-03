class tomcat :: catalog_tomcat($snapdeal_db_user, $snapdeal_db_pswd,$snapdeal_db_ip) inherits tomcat {



  file { "root.xml":
    ensure              => present,
    path            => "${tomcat::server}/conf/Catalina/localhost/",
    name        => "ROOT.xml",
    content => template('tomcat/root_template.erb'),

  }

