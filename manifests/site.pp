define nginx::site ( $ensure = 'present', $content = '', $source = '' ) {
	include nginx

if $content != '' {
	file { "/etc/nginx/sites-available/${name}":
		ensure 	=> $ensure,
		content => $content,
		mode 	=> 644,
		owner 	=> root,
		group 	=> root,
		notify 	=> Service["nginx"],
		require	=> Package["nginx"],
	}
} else {
	file { "/etc/nginx/sites-available/${name}":
		ensure 	=> $ensure,
		source => $source,
		mode 	=> 644,
		owner 	=> root,
		group 	=> root,
		notify 	=> Service["nginx"],
		require	=> Package["nginx"],
	}
}
	

	case $ensure {
		'present': {
			file { "/etc/nginx/sites-enabled/${name}":
				ensure => link,
				target => "/etc/nginx/sites-available/${name}",
			}
		}
		'absent': {
			file { "/etc/nginx/sites-enabled/${name}":
				ensure => absent,
			}
		}
	}
}

