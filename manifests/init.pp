# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include atop
class atop {
  case $::osfamily {
    'RedHat': {

    }
    'Debian': {

    }
    default: {
      fail("${::osfamily} not supported")
    }
  }
}
