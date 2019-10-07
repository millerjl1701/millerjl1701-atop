# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include atop
class atop (
  Stdlib::Unixpath           $defaults_file                  = '/etc/sysconfig/atop',
  String                     $defaults_file_template         = 'atop/atop_defaults.erb',
  Integer                    $loggenerations                 = 28,
  Integer                    $loginterval                    = 600,
  String                     $logopts                        = '-R',
  Boolean                    $manage_epel                    = false,
  Boolean                    $manage_package                 = true,
  Boolean                    $manage_service_atop            = true,
  Boolean                    $manage_service_atopacctd       = true,
  String                     $package_ensure                 = 'present',
  String                     $package_name                   = 'atop',
  String                     $process_accting_package_ensure = 'present',
  Boolean                    $process_accting_package_manage = true,
  String                     $process_accting_package_name   = 'psacct',
  String                     $process_accting_service_ensure = 'stopped',
  Boolean                    $process_accting_service_enable = false,
  Boolean                    $process_accting_service_manage = true,
  String                     $process_accting_service_name   = 'psacct',
  Boolean                    $service_atop_enable            = true,
  Enum['running', 'stopped'] $service_atop_ensure            = 'running',
  String                     $service_atop_name              = 'atop',
  Boolean                    $service_atopacctd_enable       = true,
  Enum['running', 'stopped'] $service_atopacctd_ensure       = 'running',
  String                     $service_atopacctd_name         = 'atopacct',
) {
  case $::osfamily {
    'RedHat': {
      contain atop::repo
      contain atop::install
      contain atop::config
      contain atop::service

      Class['atop::repo']
      ->Class['atop::install']
      ->Class['atop::config']
      ~>Class['atop::service']
    }
    'Debian': {
      contain atop::install
      contain atop::config
      contain atop::service

      Class['atop::install']
      ->Class['atop::config']
      ~>Class['atop::service']
    }
    default: {
      fail("${::osfamily} not supported")
    }
  }
}
