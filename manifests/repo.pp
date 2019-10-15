# @api private
#
# This class is called from the main class to add epel if desired.
#
class atop::repo {
  assert_private('atop::repo is a private class')

  if $atop::manage_epel {
    include epel
  }
}
