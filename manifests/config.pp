# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include atop::config
class atop::config {
  assert_private('atop::config is a private class')

  $_loggenerations = $atop::loggenerations
  $_loginterval = $atop::loginterval
  $_logopts = $atop::logopts

  file { $atop::defaults_file:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($atop::defaults_file_template),
  }
}
