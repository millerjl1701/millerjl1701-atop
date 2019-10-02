require 'spec_helper'

describe 'atop' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
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
