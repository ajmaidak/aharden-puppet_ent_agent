# manages puppet.conf
class puppet_ent_agent::config {
  $config            = $::puppet_ent_agent::config
  $agent_server      = $::puppet_ent_agent::agent_server
  $agent_caserver    = $::puppet_ent_agent::agent_caserver
  $agent_environment = $::puppet_ent_agent::agent_environment
  $agent_fileserver  = $::puppet_ent_agent::agent_fileserver

  Ini_setting {
    ensure  => present,
    path    => $config,
    section => 'main',
    require => File[$config],
    notify  => Service['pe-puppet'],
  }

  case $::osfamily {
    'AIX': {
      include ::puppet_ent_agent::config::symlinks

      file { $config:
        ensure => file,
        owner  => 'puppet',
        group  => 'puppet',
        mode   => '0600',
      }
    }
    'windows': {
      file { $config:
        ensure => file,
      }
    }
    default: {
      include ::puppet_ent_agent::config::symlinks

      file { $config:
        ensure => file,
        owner  => 'pe-puppet',
        group  => 'pe-puppet',
        mode   => '0600',
      }
    }
  }

  if $agent_server {
    ini_setting { 'agent_server':
      setting => 'server',
      value   => $agent_server,
    }
  }

  if $agent_caserver {
    ini_setting { 'agent_caserver':
      setting => 'ca_server',
      value   => $agent_caserver,
    }
  }

  if $agent_fileserver {
    ini_setting { 'agent_fileserver':
      setting => 'archive_file_server',
      value   => $agent_fileserver,
    }
  }

  if $agent_environment {
    ini_setting { 'agent_environment':
      section => 'agent',
      setting => 'environment',
      value   => $agent_environment,
    }
  }
}
