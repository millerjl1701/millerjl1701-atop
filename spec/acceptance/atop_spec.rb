require 'spec_helper_acceptance'

describe 'atop class:', unless: UNSUPPORTED_PLATFORMS.include?(os[:family]) do
  context 'atop class with specified paramaters' do
    pp = <<-EOS
    class { atop:
    }
    EOS

    # run it twice and test for idempotency
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)

  end
end
