# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include atop
class atop (
  Boolean $manage_epel = false,
) {
  case $::osfamily {
    'RedHat': {
      contain atop::repo
    }
    'Debian': {

    }
    default: {
      fail("${::osfamily} not supported")
    }
  }
}
