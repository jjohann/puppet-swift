# Defines a service to either use init scripts provided with distro or the swift-init script.
# Works in conjunction with the $swift::swift_init parameter.
#
# == Parameters
# [*name*] Name of the service to define.  Expected to be the name of the 
# main swift service (e.g. object, proxy) or a hyphenated auxilary 
# service (object-updater).
#
# [*service_name*] The name of the distro init script.
#
# [*ensure*] An override of the service ensure setting.

define swift::service(
  $service_name,
  $ensure = undef,
  $subscribe = undef,
  $provider = $::swift::params::service_provider
) {

  $parts = split($name, '-')
  $service = $parts[0]
  if count($parts) > 1 {
    $job = $parts[1]
  }

  if $swift::swift_init == false {
    service { "swift-${name}":
      name      => $service_name,
      ensure    => $ensure ? {undef => running, default=> $ensure},
      enable    => true,
      provider  => $provider,
      require   => Package["swift-${service}"],
      hasstatus => true,
      subscribe => $subscribe,
    }
  } else {
    if $ensure == undef {
      if $job != undef {
        $svc_ensure = $swift::swift_init ? {
          'main' => stopped,
          default => running,
        } 
      } else {
        $svc_ensure = running
      }
    } else {
      $svc_ensure = $ensure
    }
    service { "swift-${name}":
      start     => "/usr/bin/swift-init ${name} start",
      stop      => "/usr/bin/swift-init ${name} stop",
      restart   => "/usr/bin/swift-init ${name} restart",
      status    => "/usr/bin/swift-init ${name} status",
      provider  => 'base',
      ensure    => $svc_ensure,
      subscribe => $subscribe,
    }
  }
}
