# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include atop
class atop (
  Boolean $manage_epel    = false,
  Boolean $manage_package = true,
  String  $package_ensure = 'present',
  String  $package_name   = 'atop',
) {
  case $::osfamily {
    'RedHat': {
      contain atop::repo
      contain atop::install

      Class['atop::repo']
      ->Class['atop::install']
    }
    'Debian': {
      contain atop::install
    }
    default: {
      fail("${::osfamily} not supported")
    }
  }
}
