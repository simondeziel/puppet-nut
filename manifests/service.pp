# @!visibility private
class nut::service {

  service { $::nut::service_name:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  # The UPS drivers are daemons of their own and are not touched by restarting
  # upsd, so ups.conf changes silently keep the old driver running - and on
  # first install packaging may start the driver before its driver package and
  # ups.conf exist, leaving it failed. `ensure => running` heals that on every
  # run; the class refresh from nut::config restarts the driver on config
  # changes. On NUT >= 2.8 restarting nut-driver.target propagates to the
  # nut-driver@<ups> instances (PartOf). `enable` is left unmanaged: the units
  # are pulled in via Wants/enumerator and not all of them have an [Install]
  # section.
  if $::nut::driver_service_name {
    service { $::nut::driver_service_name:
      ensure     => running,
      hasrestart => true,
      hasstatus  => true,
    }
  }
}
