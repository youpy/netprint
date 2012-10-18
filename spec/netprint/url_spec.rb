require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include Netprint

describe URL do
  subject do
    URL.new(s, i, p)
  end

  let(:i) { 'username' }
  let(:p) { 'password' }

  context 'logged in' do
    let(:s) { 'xxxxxxxx' }

    its(:login)  { should eql('https://www.printing.ne.jp/cgi-bin/mn.cgi?i=username&p=password') }
    its(:upload) { should eql('https://www.printing.ne.jp/cgi-bin/mn.cgi?s=xxxxxxxx&c=0&m=1') }
    its(:list)   { should eql('https://www.printing.ne.jp/cgi-bin/mn.cgi?s=xxxxxxxx&c=0&m=0') }
  end

  context 'not logged in' do
    let(:s) { nil }

    its(:login)  { should eql('https://www.printing.ne.jp/cgi-bin/mn.cgi?i=username&p=password') }
  end
end
