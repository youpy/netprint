# Netprint  [![Build Status](https://secure.travis-ci.org/youpy/netprint.png)](http://secure.travis-ci.org/youpy/netprint)

A library to use netprint(https://www.printing.ne.jp/)

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

### Upload Options

```ruby
n.upload('/path/to/file.pdf', {

  # Netprint::PAPER_SIZE::A3
  # Netprint::PAPER_SIZE::A4(default)
  # Netprint::PAPER_SIZE::B4
  # Netprint::PAPER_SIZE::B5
  # Netprint::PAPER_SIZE::L
  :paper_size  => Netprint::PAPER_SIZE::B4,

  # Netprint::COLOR::SELECT_WHEN_PRINT
  # Netprint::COLOR::BW(default)
  # Netprint::COLOR::COLOR
  :color       => Netprint::COLOR::BW,

  :secret_code => '1234',
  :email       => 'foo@example.com'
})
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
