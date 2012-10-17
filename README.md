# Netprint

A library to upload file to netprint(https://www.printing.ne.jp/)

## Installation

Add this line to your application's Gemfile:

    gem 'netprint'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install netprint

## Usage

```ruby
n = Netprint::Agent.new(userid, password)
n.login

registration_code = n.upload('/path/to/file.pdf')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
