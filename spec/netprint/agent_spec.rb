# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include Netprint

describe Agent do
  before do
    @agent = Agent.new('user_id', 'password')

    stub_request(:get, 'https://www.printing.ne.jp/usr/web/NPCM0010.seam').
      to_return(read_fixture_file('login.html'))

    stub_request(:post, 'https://www.printing.ne.jp/usr/web/NPCM0010.seam').
      with(body: {
             'NPCM0010' => 'NPCM0010',
             'NPCM0010:login-btn' => 'ログイン',
             'NPCM0010:userIdOrMailads-txt' => 'user_id',
             'NPCM0010:password-pwd' => 'password',
             'controlParamKey' => 'foo',
             'javax.faces.ViewState' => 'bar'
           }
          ).
      to_return(read_fixture_file('list_empty.html'))
  end

  it 'should login' do
    @agent.should_not be_login

    @agent.login

    @agent.should be_login
  end

  shared_examples_for '#upload' do
    it 'should upload' do
      stub_request(:post, 'https://www.printing.ne.jp/usr/web/auth/NPFL0010.seam').
        with(body: {
               'NPFL0010' => 'NPFL0010',
               'display-max-rows' => '10',
               'create-document' => '',
               'controlParamKey' => 'xxx',
               'javax.faces.ViewState' => 'yyy'
             }
            ).
        to_return(read_fixture_file('upload.html'))

      stub_request(:post, 'https://www.printing.ne.jp/usr/web/auth/NPFL0020.seam').
        to_return(read_fixture_file('list_processing.html'))

      stub_request(:post, 'https://www.printing.ne.jp/usr/web/auth/NPFL0010.seam').
        with(body: {
               'NPFL0010' => 'NPFL0010',
               'display-max-rows' => '10',
               'reload' => '',
               'controlParamKey' => 'xxx',
               'javax.faces.ViewState' => 'yyy'
             }
            ).
        to_return(read_fixture_file('list_processed.html'))

      filename = File.expand_path(pdf_filename)
      @agent.login

      code = @agent.upload(filename)
      code.should match(/^[0-9A-Z]{8}$/)
    end

    it 'should handle registration error' do
      stub_request(:post, 'https://www.printing.ne.jp/usr/web/auth/NPFL0010.seam').
        with(body: {
               'NPFL0010' => 'NPFL0010',
               'display-max-rows' => '10',
               'create-document' => '',
               'controlParamKey' => 'xxx',
               'javax.faces.ViewState' => 'yyy'
             }
            ).
        to_return(read_fixture_file('upload.html'))

      stub_request(:post, 'https://www.printing.ne.jp/usr/web/auth/NPFL0020.seam').
        to_return(read_fixture_file('list_processing.html'))

      stub_request(:post, 'https://www.printing.ne.jp/usr/web/auth/NPFL0010.seam').
        with(body: {
               'NPFL0010' => 'NPFL0010',
               'display-max-rows' => '10',
               'reload' => '',
               'controlParamKey' => 'xxx',
               'javax.faces.ViewState' => 'yyy'
             }
            ).
        to_return(read_fixture_file('list_error.html'))

      filename = File.expand_path(pdf_filename)
      @agent.login

      lambda {
        @agent.upload(filename)
      }.should raise_error(RegistrationError)
    end

    it 'should handle upload error' do
      stub_request(:post, 'https://www.printing.ne.jp/usr/web/auth/NPFL0010.seam').
        with(body: {
               'NPFL0010' => 'NPFL0010',
               'display-max-rows' => '10',
               'create-document' => '',
               'controlParamKey' => 'xxx',
               'javax.faces.ViewState' => 'yyy'
             }
            ).
        to_return(read_fixture_file('upload.html'))

      stub_request(:post, 'https://www.printing.ne.jp/usr/web/auth/NPFL0020.seam').
        to_return(read_fixture_file('upload_error.html'))

      filename = File.expand_path(pdf_filename)
      @agent.login

      lambda {
        @agent.upload(filename)
      }.should raise_error(UploadError, 'error message')
    end
  end

  context 'filename is ASCII only' do
    let(:pdf_filename) { fixture_file('foo.pdf') }

    it_should_behave_like '#upload'
  end

  context 'filename has non-ASCII characters' do
    let(:pdf_filename) { fixture_file('あいうえお.pdf') }

    it_should_behave_like '#upload'
  end
end
