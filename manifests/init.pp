class petclinic-2 {

  exec { 'clean-tmp':
                command => 'rm -rf /tmp/petclinic*',
                path => ['/bin'],
        }
     exec { 'petclinic-war':
      	      require => [ 
	      	      Service['tomcat6'], 
		      Package['wget']
	      ],
	      command => 'wget http://jenkins-v.puppet-demo.beesshop.org:8080/job/petclinic-artifact/lastSuccessfulBuild/artifact/target/petclinic.war -P /tmp/',
	      path => ['/usr/bin'],
      }

      exec { 'delete-war-from-webapps':
	      command => 'rm -rf /var/lib/tomcat6/webapps/petclinic*',
	      path => ['/bin'],
     }

      file { '/var/lib/tomcat6/webapps/petclinic.war':
      	   source => '/tmp/petclinic.war',
	   require => Exec['petclinic-war', 'delete-war-from-webapps'],
      }

    
	exec { 'restart-tomcat7':
		command => 'tomcat6 restart',
		path => ['/etc/init.d'],
	}
}
