# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include atop::install
class atop::install {
  assert_private('atop::install is a private class')

  if $atop::manage_package {
    package { $atop::package_name:
      ensure => $atop::package_ensure,
    }
  }
}
