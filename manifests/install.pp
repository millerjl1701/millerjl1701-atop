# @api private
#
# This class is called from the main class to install atop.
#
class atop::install {
  assert_private('atop::install is a private class')

  if $atop::manage_package {
    ensure_packages( [ $atop::package_name, ], { 'ensure' => $atop::package_ensure,})
  }

  if $atop::process_accting_package_manage {
    ensure_packages( [ $atop::process_accting_package_name, ], { 'ensure' => $atop::process_accting_package_ensure,})
  }
}
