# manages upgrades of Puppet Enterprise agent when needed
class puppet_ent_agent::install inherits puppet_ent_agent {
  $ensure         = $::puppet_ent_agent::ensure
  $windows_source = $::puppet_ent_agent::windows_source

  if $ensure != 'present' {
    case $::osfamily {
      'windows': {
        if $windows_source {
          include ::puppet_ent_agent::install::windows
        } else {
          notify { 'Windows repository not available: source not defined.': }
        }
      }
      default: {
        include ::puppet_ent_agent::install::nix
      }
    }
  }
}
