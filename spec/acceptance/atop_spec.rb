require 'spec_helper_acceptance'

describe 'atop class:', unless: UNSUPPORTED_PLATFORMS.include?(os[:family]) do
  context 'atop class with specified paramaters' do
    pp = <<-EOS
    class { atop:
      manage_epel => true,
    }
    EOS

    # run it twice and test for idempotency
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)
    
    if fact('os.family') == 'RedHat'
      describe yumrepo('epel') do
        it { should exist }
        it { should be_enabled }
      end
    end

    describe package('atop') do
      it { should be_installed }
    end
  end
end
