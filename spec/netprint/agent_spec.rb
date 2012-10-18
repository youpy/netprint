require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include Netprint

describe Agent do
  before do
    @agent = Agent.new('user_id', 'password')

    stub_request(:get, 'https://www.printing.ne.jp/cgi-bin/mn.cgi?i=user_id&p=password').
      to_return(open(File.expand_path(File.dirname(__FILE__) + '/../list.html')).read)
  end

  it 'should login' do
    @agent.should_not be_login

    @agent.login

    @agent.should be_login
  end

  it 'should upload' do
    stub_request(:get, 'https://www.printing.ne.jp/cgi-bin/mn.cgi?c=0&m=1&s=qwertyuiopoiuytrewq').
      to_return(open(File.expand_path(File.dirname(__FILE__) + '/../upload.html')).read)
    stub_request(:post, 'https://www.printing.ne.jp/cgi-bin/mn.cgi?c=0&m=1&s=qwertyuiopoiuytrewq').
      to_return(open(File.expand_path(File.dirname(__FILE__) + '/../list.html')).read)
    stub_request(:get, 'https://www.printing.ne.jp/cgi-bin/mn.cgi?c=0&m=0&s=qwertyuiopoiuytrewq').
      to_return(open(File.expand_path(File.dirname(__FILE__) + '/../list.html')).read)

    filename = File.expand_path(File.dirname(__FILE__) + '/../foo.pdf')
    @agent.login

    code = @agent.upload(filename)
    code.should match(/^[0-9A-Z]{8}$/)
  end
end
