# atop
#
# @summary
#   Puppet module for installation, configuration, and management of the atop performance monitor.

# Main class that includes private classes (repo, install, config, service).
#
# @param defaults_file
#   Path to the atop defaults configuration file. Default value on RedHat: '/etc/sysconfig/atop'. Default value on Debian: '/etc/default/atop'.
#
# @param defaults_file_template
#   Specifies the ERB template to use for the defaults file. Default value: 'atop/atop_defaults.erb'.
#   There are other operating system version specific defaults template depending on the version of atop installed.
#
# @param loggenerations
#   Specifies the number of days of logfiles to keep. Default value: 28.
#
# @param loginterval
#   Specifies the interval in seconds. Default value: 600.
#
# @param logopts
#   Speficies the default options for the atop service. Default value: '-R'.
#
# @param manage_epel
#   Whether or not to manage epel on the system. Default value: false.
#
# @param manage_package
#   Whether or not to manage the installation of the atop package. Default value: true.
#
# @param manage_service_atop
#   Whether or not to manage the atop service. Default value: true.
#
# @param manage_service_atopacctd
#   Whether or not to manage the atopacctd service. Default value: true.
#
# @param package_ensure
#   Whether to install the atop package, and what version to install. Default value: 'present'.
#   Values: 'present', 'latest', 'absent', or a specific version number.
#
# @param package_name
#   Specifies the name of the atop package to manage. Default value: 'atop'.
#
# @param process_accting_package_ensure
#   Whether to install the psacct (acct on Debian) package for process accounting and what version. Default value: 'present'.
#
# @param process_accting_package_manage
#   Whether or not to manage the process acounting package. Default value: true.
#
# @param process_accting_package_name
#   Specifies the name of the process accounting package to manage. Default value on RedHat: 'psacct'. Default value on Debian: 'acct'.
#
# @param process_accting_service_ensure
#   Whether the process accounting service should be running. Varies depending on whether or not atopacct need this running as well.
#
# @param process_accting_service_enable
#   Whether to enable the process accounting service at boot. Varies depending on whether or not atopacct need this running as well.
#
# @param process_accting_service_manage
#   Whether or not to manage the process accounting service. Default value: true.
#
# @param process_accting_service_name
#   Specifies the name of the process accounting service. Varies depending on the operating system, but defaults to 'psacct'.
#
# @param service_atop_enable
#   Whether to enable the atop service at boot. Default value: true.
#
# @param service_atop_ensure
#   Whether the atop service should be running. Default value: 'running'.
#
# @param service_atop_name
#   Specifies the name of the atop service. Default value: 'atop'.
#
# @param service_atopacctd_enable
#   Whether to enable the atopacctd daemon. Varies depending on the operating system.
#
# @param service_atopacctd_ensure
#   Whether the atopacctd service should be running. Varies depending on the operating system.
#
# @param service_atopacctd_name
#   Specifies the name of the atopacctd service. Default value: 'atopacct'.
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
