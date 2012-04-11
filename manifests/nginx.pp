class nginx ($ensure = present, $nginx_user = 'www-data', $worker_connections = 8192, $worker_rlimit_nofile = 131072, $keepalive_timeout = 20) {

	package { "nginx": ensure => $ensure }

	service { "nginx":
    ensure 		=> $ensure ? {
      present => running,
      absent  => stopped,
    },
    enable 		=> true,
    hasrestart 	=> true,
    require 	=> File["/etc/nginx/nginx.conf"],
  }

  file { "/etc/nginx/nginx.conf":
    ensure 	=> $ensure,
    mode 	=> 644,
    owner 	=> root,
    group 	=> root,
    content => template("nginx/nginx.conf.erb"),
    notify 	=> Service["nginx"],
    require => Package["nginx"],
  }

  file { "/etc/nginx/conf.d":
    ensure 	=> $ensure ? {
      present => directory,
      absent  => absent,
    },
    recurse	=> true,
    purge	=> true,
    force	=> true,
    mode	=> 644, 
    owner 	=> root, 
    group 	=> root,
    require => Package["nginx"],
  }

	file { "/etc/nginx/ssl":
		ensure 	=> $ensure ? {
			present => directory,
			absent  => absent,
		},
		recurse => true,
		purge	=> true,
		force	=> true,
		mode 	=> 644,
		owner 	=> root, 
		group 	=> root,
		require => Package["nginx"],
	}

	file { "/etc/nginx/includes":
		ensure 	=> $ensure ? {
			present => directory,
			absent  => absent,
		},
		recurse	=> true,
		purge	=> true,
		force	=> true,
		mode 	=> 644, 
		owner 	=> root, 
		group 	=> root,
		require => Package["nginx"],
	}

	file { "/etc/nginx/sites-enabled":
		ensure 	=> $ensure ? {
			present => directory,
			absent  => absent,
		},
		recurse => true,
		purge 	=> true,
		force   => true,
		mode 	=> 644,
		owner 	=> root,
		group 	=> root,
		require => Package["nginx"],
	}

	file { "/etc/nginx/sites-available":
		ensure 	=> $ensure ? {
			present => directory,
			absent  => absent,
		},
		recurse => true,
		purge	=> true,
		force   => true,
		mode	=> 644,
		owner	=> root,
		group	=> root,
		require => Package["nginx"],
	}

#	file { "/etc/nginx/fastcgi_params":
#		ensure 	=> absent,
#		require => Package["nginx"],
#	}

	exec { "reload-nginx":
		command 	=> "/etc/init.d/nginx reload",
        refreshonly => true,
    }

	# Define: nginx::config
	#
	# Define a nginx config snippet. Places all config snippets into
	# /etc/nginx/conf.d, where they will be automatically loaded by http module
	#
	#
	# Parameters :
	# * ensure: typically set to "present" or "absent". Defaults to "present"
	# * content: set the content of the config snipppet. Defaults to 'template("nginx/${name}.conf.erb")'
	# * order: specifies the load order for this config snippet. Defaults to "500"
	#
#    define config ( $ensure = 'present', $content = '', $order="500") {
#    	$real_content = $content ? { 
#			'' 		=> template("nginx/${name}.conf.erb"),
#        	default => $content,
#        }
#
#        file { "${nginx_conf}/${order}-${name}.conf":
#			ensure 	=> $ensure,
#			content => $real_content,
#			mode 	=> 644,
#			owner 	=> root,
#			group 	=> root,
#			notify 	=> Service["nginx"],
#    	}
#    }

	define config ($ensure = present, $content = undef, $source = undef, $order = 10) {
		file { "/etc/nginx/conf.d/${order}-${name}.conf":
			ensure => $ensure,
			content => $content,
			source => $source,
			mode => 644,
			owner => root,
			group => root,
			notify => Service["nginx"],
		}
	}


	# Define: site_include
	#
	# Define a site config include in /etc/nginx/includes
	#
	# Parameters :
	# * ensure: typically set to "present" or "absent". Defaults to "present"
	# * content: include definition (should be a template).
	#
#	define site_include ( $ensure = 'present', $content = '' ) {
#		file { "${nginx_includes}/${name}.inc":
#			content => $content,
#			mode => 644,
#			owner => root,
#			group => root,
#			ensure => $ensure,
#			require => File["${nginx_includes}"],
#			notify => Exec["reload-nginx"],
#		}    
#	}


}
