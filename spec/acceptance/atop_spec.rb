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

    describe service('atop') do
      it { should be_enabled }
      it { should be_running }
    end

    if fact('os.family') == 'RedHat'
      describe file('/etc/sysconfig/atop') do
        it { should be_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        it { should be_mode 644 }
        its(:content) { should match /# puppet managed file. local changes will be overwritten/ }
      end
      if fact('os.release.major') == '6'
        describe file('/etc/sysconfig/atop') do
          its(:content) { should match /LOGPATH=\/var\/log\/atop/ }
          its(:content) { should match /BINPATH=\/usr\/bin/ }
          its(:content) { should match /PIDFILE=\/var\/run\/atop.pid/ }
          its(:content) { should match /INTERVAL=600/ }
        end

        describe service('psacct') do
          it { should be_enabled }
          it { should be_running }
        end
      else
        describe file('/etc/sysconfig/atop') do
          its(:content) { should match /LOGINTERVAL=600/ }
          its(:content) { should match /LOGGENERATIONS=28/ }
          its(:content) { should match /LOGOPTS=\"-R\"/ }
        end

        describe service('psacct') do
          it { should_not be_enabled }
          it { should_not be_running }
        end

        describe service('atopacct') do
          it { should be_enabled }
          it { should be_running }
        end
      end
    else
      describe file('/etc/default/atop') do
        it { should be_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        it { should be_mode 644 }
        its(:content) { should match /# puppet managed file. local changes will be overwritten/ }
      end

      if fact('os.release.major') == '16.04'
        describe file('/etc/default/atop') do
          its(:content) { should match /INTERVAL=600/ }
        end

        describe service('acct') do
          it { should be_enabled }
          it { should be_running }
        end
      elsif fact('os.release.major') == '8'
        describe file('/etc/default/atop') do
          its(:content) { should match /INTERVAL=600/ }
        end

        describe service('acct') do
          it { should be_enabled }
          it { should be_running }
        end
      else
        describe file('/etc/default/atop') do
          its(:content) { should match /# this file is no longer used and will be removed in a future release/ }
        end

        describe service('acct') do
          it { should_not be_enabled }
          it { should_not be_running }
        end
        describe service('atopacct') do
          it { should be_enabled }
          it { should be_running }
        end
      end

    end
  end
end
