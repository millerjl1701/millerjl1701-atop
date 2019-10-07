# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include atop::install
class atop::install {
  assert_private('atop::install is a private class')

  if $atop::manage_package {
    ensure_packages( [ $atop::package_name, ], { 'ensure' => $atop::package_ensure,})
  }

  if $atop::process_accting_package_manage {
    ensure_packages( [ $atop::process_accting_package_name, ], { 'ensure' => $atop::process_accting_package_ensure,})
  }
}
