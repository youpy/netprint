# -*- coding: utf-8 -*-
require "tmpdir"
require "fileutils"
require "pathname"

module Netprint
  class Agent
    attr_reader :userid, :password

    include FileUtils

    def initialize(userid, password)
      @userid   = userid
      @password = password
    end

    def login
      page        = mechanize.get(login_url)
      @session_id = page.links[0].href.match(/s=(\w+)/)[1]
    end

    def upload(filename)
      raise 'not logged in' unless login?

      Dir.mktmpdir do |dir|
        upload_filename  = (Pathname(dir) + ([Time.now.to_f.to_s, File.basename(filename)].join('_'))).to_s
        cp filename, upload_filename

        page = mechanize.get(upload_url)
        page = page.form_with(:name => 'uploadform') do |form|
          form.file_uploads.first.file_name = upload_filename
          form['papersize']    = '0'
          form['color']        = '0'
          form['number']       = '0'
          form['secretcodesw'] = '0'
          form['mailsw']       = '0'
        end.submit

        raise UploadError if page.search('//img[@src="/img/icn_error.jpg"]').size == 1

        get_code
      end
    end

    def login?
      @session_id
    end

    private

    def get_code
      code = nil

      loop do
        page = mechanize.get(list_url)
        _, registered_name, status = page.search('//tr[@bgcolor="#CFCFE6"][1]/td')

        if status.text  =~ /^[0-9A-Z]{8}+$/
          code = status.text
          break
        elsif status.text == 'エラー'
          raise RegistrationError
        end

        sleep 1
      end

      code
    end

    def upload_url
      expand_url(:s => @session_id, :c => 0, :m => 1)
    end

    def list_url
      expand_url(:s => @session_id, :c => 0, :m => 0)
    end

    def login_url
      expand_url(:i => userid, :p => password)
    end

    def expand_url(params)
      Addressable::Template.new('https://www.printing.ne.jp/cgi-bin/mn.cgi?{-join|&|i,p,s,c,m}').
        expand(params)
    end

    def mechanize
      @mechanize ||= Mechanize.new
    end
  end
end
