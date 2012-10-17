require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include Netprint

describe Agent do
  before do
    unless ENV['NETPRINT_USERID'] && ENV['NETPRINT_PASSWORD']
      raise 'set environment variable NETPRINT_USERID and NETPRINT_PASSWORD before running spec'
    end

    @agent = Agent.new(ENV['NETPRINT_USERID'], ENV['NETPRINT_PASSWORD'])
  end

  it 'should login' do
    @agent.should_not be_login

    @agent.login

    @agent.should be_login
  end

  it 'should upload' do
    filename = File.expand_path(File.dirname(__FILE__) + '/../foo.pdf')
    @agent.login

    code = @agent.upload(filename)
    code.should match(/^[0-9A-Z]{8}$/)
  end
end
