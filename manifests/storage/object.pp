class swift::storage::object(
  $package_ensure = 'present',
  $service_ensure = undef,
) {
  swift::storage::generic { 'object':
    package_ensure => $package_ensure,
    service_ensure => $service_ensure,
  }

  swift::service{ 'object-updater':
    service_name => $::swift::params::object_updater_service_name,
  }
  swift::service{ 'object-auditor':
    service_name => $::swift::params::object_auditor_service_name,
  }
}
