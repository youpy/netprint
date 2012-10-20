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
      page        = mechanize.get(url.login)
      @session_id = page.links[0].href.match(/s=([^&]+)/)[1]
    end

    def upload(filename, options = {})
      raise 'not logged in' unless login?

      options = Options.new(options)

      Dir.mktmpdir do |dir|
        upload_filename  = (Pathname(dir) + ([Time.now.to_f.to_s, File.basename(filename)].join('_'))).to_s
        cp filename, upload_filename

        page = mechanize.get(url.upload)
        page = page.form_with(:name => 'uploadform') do |form|
          form.file_uploads.first.file_name = upload_filename
          options.apply(form)
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
        page = mechanize.get(url.list)
        _, registered_name, status = page.search('//tr[@bgcolor="#CFCFE6" or @bgcolor="#ff6666"][1]/td')

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

    def url
      URL.new(@session_id, userid, password)
    end

    def mechanize
      @mechanize ||= Mechanize.new
    end
  end
end
