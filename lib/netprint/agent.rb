# -*- coding: utf-8 -*-
require "tmpdir"
require "fileutils"
require "pathname"
require 'digest/md5'

module Netprint
  class Agent
    attr_reader :userid, :password

    include FileUtils

    def initialize(userid, password)
      @userid   = userid
      @password = password
      @page = nil
    end

    def login
      @page = mechanize.get('https://www.printing.ne.jp/usr/web/NPCM0010.seam')
      form = @page.form_with(name: 'NPCM0010')
      form.field_with(name: 'NPCM0010:userIdOrMailads-txt').value = @userid
      form.field_with(name: 'NPCM0010:password-pwd').value = @password
      @page = form.submit(form.button_with(name: 'NPCM0010:login-btn'))
    end

    def upload(filename, options = {})
      raise 'not logged in' unless login?

      form = @page.form_with(name: 'NPFL0010')
      @page = form.submit(form.button_with(name: 'create-document'))

      options = Options.new(options)

      Dir.mktmpdir do |dir|
        upload_filename  = (Pathname(dir) + ([
              Time.now.to_f.to_s,
              Digest::MD5.hexdigest(filename).to_s,
              File.basename(filename).gsub(/[^\w]+/, '') + File.extname(filename)
            ].join('_'))).to_s
        cp filename, upload_filename

        form = @page.form_with(name: 'NPFL0020')
        form.file_uploads.first.file_name = upload_filename
        options.apply(form)
        @page = form.submit(form.button_with(name: 'update-ow-btn'))

        raise UploadError if @page.search('//ul[@id="svErrMsg"]/li').size == 1

        get_code
      end
    end

    def login?
      @page && @page.code == '200'
    end

    private

    def reload
      form = @page.form_with(name: 'NPFL0010')
      @page = form.submit(form.button_with(name: 'reload'))
    end

    def get_code
      code = nil

      loop do
        reload

        _, _, status = @page.search('//tbody/tr')[0].search('td')

        if status.text =~ /^[0-9A-Z]{8}+$/
          code = status.text
          break
        elsif status.text =~ /エラー/
          raise RegistrationError
        end

        sleep 1
      end

      code
    end

    def mechanize
      @mechanize ||= Mechanize.new
      @mechanize.ssl_version = :TLSv1
      @mechanize
    end
  end
end
