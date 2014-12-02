#
# === Parameters
#
# [*allowed_sync_hosts*] A list of hosts allowed in the X-Container-Sync-To
#   field for containers. Defaults to one entry list '127.0.0.1'.
#
class swift::storage::container(
  $package_ensure = 'present',
  $allowed_sync_hosts = ['127.0.0.1'],
  $service_ensure = undef,
) {
  swift::storage::generic { 'container':
    package_ensure => $package_ensure,
    service_ensure => $service_ensure,
  }

  include swift::params

  swift::service{ 'container-updater':
    service_name => $::swift::params::container_updater_service_name,
  }
  swift::service{ 'container-auditor':
    service_name => $::swift::params::container_auditor_service_name,
  }

  if $::operatingsystem == 'Ubuntu' and $::swift::swift_init == false {
    # The following service conf is missing in Ubuntu 12.04
    file { '/etc/init/swift-container-sync.conf':
      source  => 'puppet:///modules/swift/swift-container-sync.conf.upstart',
      require => Package['swift-container'],
    }
    file { '/etc/init.d/swift-container-sync':
      ensure => link,
      target => '/lib/init/upstart-job',
    }
    service { 'swift-container-sync':
      ensure    => running,
      enable    => true,
      provider  => $::swift::params::service_provider,
      require   => File['/etc/init/swift-container-sync.conf', '/etc/init.d/swift-container-sync']
    }
  }
}
