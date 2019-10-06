require 'spec_helper'

describe 'atop' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context "atop class without any parameters changed from defaults" do
        it { is_expected.to compile }

        if os_facts[:os]['family'] == 'RedHat'
          it { is_expected.to contain_class('atop::repo') }
          it { is_expected.to contain_class('atop::repo').that_comes_before('Class[atop::install]') }
          it { is_expected.to_not contain_class('epel') }

          it { is_expected.to contain_file('/etc/sysconfig/atop').with(
            'ensure' => 'present',
            'owner' => 'root',
            'group' => 'root',
            'mode' => '0644',
          ) }
          it { is_expected.to contain_file('/etc/sysconfig/atop').with_content(/# puppet managed file. local changes will be overwritten/) }

          if os_facts[:os]['release']['major'] == '6'
            it { is_expected.to contain_file('/etc/sysconfig/atop').with_content(/INTERVAL=600/) }
          else
            it { is_expected.to contain_file('/etc/sysconfig/atop').with_content(/LOGINTERVAL=600/) }
          end
        else
          it { is_expected.to_not contain_class('atop::repo') }
          it { is_expected.to_not contain_class('epel') }

          it { is_expected.to contain_file('/etc/default/atop').with(
            'ensure' => 'present',
            'owner' => 'root',
            'group' => 'root',
            'mode' => '0644',
          ) }
          it { is_expected.to contain_file('/etc/default/atop').with_content(/# puppet managed file. local changes will be overwritten/) }
          case os_facts[:os]['release']['major']
          when '16.04'
            it do
              is_expected.to contain_file('/etc/default/atop').with_content(/INTERVAL=600/)
            end
          when '8'
            it do
              is_expected.to contain_file('/etc/default/atop').with_content(/INTERVAL=600/)
            end
          else
            # noop since no valid parameters for ubuntu 18.04 or Debian 9/10
            it { is_expected.to contain_file('/etc/default/atop').with_content(/# this file is no longer used and will be removed in a future release/) }
          end
        end

        it { is_expected.to contain_class('atop::install') }
        it { is_expected.to contain_class('atop::config') }
        it { is_expected.to contain_class('atop::install').that_comes_before('Class[atop::config]') }

        it { is_expected.to contain_package('atop').with_ensure('present') }

      end

      context "atop class with defaults_file set to /etc/atop.conf" do
        let(:params) { { :defaults_file => '/etc/atop.conf' } }

        it { is_expected.to contain_file('/etc/atop.conf').with(
          'ensure' => 'present',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0644',
        ) }
        it { is_expected.to contain_file('/etc/atop.conf').with_content(/# puppet managed file. local changes will be overwritten/) }
        if os_facts[:os]['release']['major'] == '6'
          it { is_expected.to contain_file('/etc/atop.conf').with_content(/INTERVAL=600/) }
        else
          case os_facts[:os]['release']['major']
          when '16.04'
            it { is_expected.to contain_file('/etc/atop.conf').with_content(/INTERVAL=600/) }
          when '8'
            it { is_expected.to contain_file('/etc/atop.conf').with_content(/INTERVAL=600/) }
          else
            # noop since no valid parameters for ubuntu 18.04 or Debian 9/10
          end
        end
      end

      context "atop class with loggenerations set to 45" do
        let(:params) { { :loggenerations => 45 } }

        if os_facts[:os]['family'] == 'RedHat'
          if os_facts[:os]['release']['major'] == '6'
            # noop since logopts not used
          else
            it { is_expected.to contain_file('/etc/sysconfig/atop').with_content(/LOGGENERATIONS=45/) }
          end
        else
          # noop since not valid parameter on debian or ubuntu
        end
      end

      context "atop class with loginterval set to 3600" do
        let(:params) { { :loginterval => 3600 } }

        if os_facts[:os]['family'] == 'RedHat'
          if os_facts[:os]['release']['major'] == '6'
            it { is_expected.to contain_file('/etc/sysconfig/atop').with_content(/INTERVAL=3600/) }
          else
            it { is_expected.to contain_file('/etc/sysconfig/atop').with_content(/LOGINTERVAL=3600/) }
          end
        else
          case os_facts[:os]['release']['major']
          when '16.04'
            it { is_expected.to contain_file('/etc/default/atop').with_content(/INTERVAL=3600/) }
          when '8'
            it { is_expected.to contain_file('/etc/default/atop').with_content(/INTERVAL=3600/) }
          else
            # noop since no valid parameters for ubuntu 18.04 or Debian 9/10
          end
        end
      end

      context "atop class with logopts set to -1R" do
        let(:params) { { :logopts => '-1R' } }

        if os_facts[:os]['family'] == 'RedHat'
          if os_facts[:os]['release']['major'] == '6'
            # noop since logopts not used
          else
            it { is_expected.to contain_file('/etc/sysconfig/atop').with_content(/LOGOPTS=\"-1R\"/) }
          end
        else
          # noop since not valid parameter on debian or ubuntu
        end
      end

      context "atop class with manage_epel set to true" do
        let(:params) { { :manage_epel => true } }

        if os_facts[:os]['family'] == 'RedHat'
          it { is_expected.to contain_class('epel') }
        else
          it { is_expected.to_not contain_class('epel') }
        end
      end

      context "atop class with manage_package set to false" do
        let(:params) { { :manage_package => false } }

        it { is_expected.to_not contain_package('atop') }
      end

      context "atop class with package_ensure set to 2.4.0" do
        let(:params) { { :package_ensure => '2.4.0' } }

        it { is_expected.to contain_package('atop').with_ensure('2.4.0') }
      end

      context "atop class with package_name set to foo" do
        let(:params) { { :package_name => 'foo' } }

        it { is_expected.to contain_package('foo') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'atop class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('atop') }.to raise_error(Puppet::Error, /Solaris not supported/) }
    end
  end
end
