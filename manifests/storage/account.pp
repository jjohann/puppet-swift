class swift::storage::account(
  $package_ensure = 'present',
  $service_ensure = undef
) {
  swift::storage::generic { 'account':
    package_ensure => $package_ensure,
    service_ensure => $service_ensure,
  }
  swift::service{ 'account-reaper':
    service_name => $::swift::params::account_reaper_service_name,
  }

  swift::service{ 'account-auditor':
    service_name => $::swift::params::account_auditor_service_name,
  }
}
