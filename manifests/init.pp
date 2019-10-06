# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include atop
class atop (
  Stdlib::Unixpath  $defaults_file          = '/etc/sysconfig/atop',
  String            $defaults_file_template = 'atop/atop_defaults.erb',
  Integer           $loggenerations         = 28,
  Integer           $loginterval            = 600,
  String            $logopts                = '-R',
  Boolean           $manage_epel            = false,
  Boolean           $manage_package         = true,
  String            $package_ensure         = 'present',
  String            $package_name           = 'atop',
) {
  case $::osfamily {
    'RedHat': {
      contain atop::repo
      contain atop::install
      contain atop::config

      Class['atop::repo']
      ->Class['atop::install']
      ->Class['atop::config']
    }
    'Debian': {
      contain atop::install
      contain atop::config

      Class['atop::install']
      ->Class['atop::config']
    }
    default: {
      fail("${::osfamily} not supported")
    }
  }
}
