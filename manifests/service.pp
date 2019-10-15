# @api private
#
# This class is called from the main class to manage the atop service.
#
# @example
#   include atop::service
class atop::service {
  assert_private('atop::service is a private class')

  if $atop::manage_service_atop {
    service { $atop::service_atop_name:
      ensure => $atop::service_atop_ensure,
      enable => $atop::service_atop_enable,
    }
  }

  if $atop::process_accting_service_manage {
    service { $atop::process_accting_service_name:
      ensure => $atop::process_accting_service_ensure,
      enable => $atop::process_accting_service_enable,
    }
  }

  if $atop::manage_service_atopacctd {
    service { $atop::service_atopacctd_name:
      ensure  => $atop::service_atopacctd_ensure,
      enable  => $atop::service_atopacctd_enable,
    }
  }
}
