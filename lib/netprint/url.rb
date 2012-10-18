module Netprint
  class URL
    def initialize(session_id, userid, password)
      @session_id = session_id
      @userid     = userid
      @password   = password
    end

    def login
      expand(:i => @userid, :p => @password)
    end

    def upload
      expand(:s => @session_id, :c => 0, :m => 1)
    end

    def list
      expand(:s => @session_id, :c => 0, :m => 0)
    end

    private

    def expand(params)
      Addressable::Template.new(template).
        expand(params).
        to_str
    end

    def template
      Addressable::VERSION::STRING >= '2.2.7' ?
        'https://www.printing.ne.jp/cgi-bin/mn.cgi{?i,p,s,c,m}' :
        'https://www.printing.ne.jp/cgi-bin/mn.cgi?{-join|&|i,p,s,c,m}'
    end
  end
end
