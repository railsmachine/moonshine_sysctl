require File.join(File.dirname(__FILE__), 'spec_helper.rb')

class SysctlManifest < Moonshine::Manifest
  require "#{File.dirname(__FILE__)}/../lib/sysctl.rb"
  include Sysctl
end

describe "A manifest with the Sysctl plugin" do

  before do
    @manifest = SysctlManifest.new
    @manifest.configure(:sysctl => {'net.ipv4.tcp_tw_reuse' => 1})
  end

  it "should be executable" do
    @manifest.should be_executable
  end

  it "should configure sysctl params" do
    @manifest.sysctl
    @manifest.files['/etc/sysctl.d/99-moonshine.conf'].should_not be_nil
    @manifest.files['/etc/sysctl.d/99-moonshine.conf'].should_match =~ /tcp_tw_reuse = 1/
    @manifest.execs['invoke-rc.d procps start'].should_not be_nil
  end
end