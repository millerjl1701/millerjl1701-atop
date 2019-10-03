# @api private
#
# This class manages the addition of needed repositories for atop.
#
class atop::repo {
  assert_private('atop::repo is a private class')

  if $atop::manage_epel {
    include epel
  }
}
