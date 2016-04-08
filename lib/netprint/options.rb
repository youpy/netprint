module Netprint
  class Options
    attr_reader :options

    def initialize(options = {})
      @options = {
        :paper_size  => PAPERSIZE::A4,
        :color       => COLOR::BW,
        :code_type   => CODE_TYPE::ALNUM,
        :secret_code => nil,
        :email       => nil
      }.merge(options)
    end

    def apply(form)
      check_radiobutton(form, 'yus-size',       options[:paper_size])
      check_radiobutton(form, 'iro-cl',         options[:color])
      check_radiobutton(form, 'yyk-type-cl',    options[:code_type])
      check_radiobutton(form, 'pin-num-set-fl', options[:secret_code] =~ /^\d{4}$/ ? '1' : '0')
      check_radiobutton(form, 'notice-onoff',   options[:email] ? '1' : '0')

      form['pin-no']         = options[:secret_code] if options[:secret_code] =~ /^\d{4}$/
      form['mail-adr-to-tx'] = options[:email]       if options[:email]
    end

    private

    def check_radiobutton(form, name, value)
      form.radiobutton_with(:name => name, :value => value).check
    end
  end
end
