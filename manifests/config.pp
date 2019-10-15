# @summary
#   This class is called from the main class to configure the atop service.
#
# @api private
#
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
