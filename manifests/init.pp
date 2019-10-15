# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include atop
class atop (
  Stdlib::Unixpath           $defaults_file,
  String                     $defaults_file_template,
  Integer                    $loggenerations,
  Integer                    $loginterval,
  String                     $logopts,
  Boolean                    $manage_epel,
  Boolean                    $manage_package,
  Boolean                    $manage_service_atop,
  Boolean                    $manage_service_atopacctd,
  String                     $package_ensure,
  String                     $package_name,
  String                     $process_accting_package_ensure,
  Boolean                    $process_accting_package_manage,
  String                     $process_accting_package_name,
  String                     $process_accting_service_ensure,
  Boolean                    $process_accting_service_enable,
  Boolean                    $process_accting_service_manage,
  String                     $process_accting_service_name,
  Boolean                    $service_atop_enable,
  Enum['running', 'stopped'] $service_atop_ensure,
  String                     $service_atop_name,
  Boolean                    $service_atopacctd_enable,
  Enum['running', 'stopped'] $service_atopacctd_ensure,
  String                     $service_atopacctd_name,
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
