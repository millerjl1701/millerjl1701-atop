require 'spec_helper'

describe 'atop' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context "atop class without any parameters changed from defaults" do
        it { is_expected.to compile }

        if os_facts[:os]['family'] == 'RedHat'
          it { is_expected.to contain_class('atop::repo') }
          it { is_expected.to_not contain_class('epel') }
        else
          it { is_expected.to_not contain_class('atop::repo') }
          it { is_expected.to_not contain_class('epel') }
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
