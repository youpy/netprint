# Netprint [![Ruby](https://github.com/youpy/netprint/actions/workflows/ruby.yml/badge.svg?branch=master)](https://github.com/youpy/netprint/actions/workflows/ruby.yml)

A library and command line tool for using [netprint](https://www.printing.ne.jp/) 

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

### CLI

```
$ netprint --help
Usage:
  netprint [--user=<userid:password>] [--email=<email>] [--secret=<secret>] <filename>
  netprint -h | --help

Options:
  -h --help                    Show this screen.
  -v --version                 Show version information.
  -u --user=<userid:password>  User account. If not specified, ENV['NETPRINT_(USERID|PASSWORD)'] is used.
  -e --email=<email>           Email address to notify. If not specified, ENV['NETPRINT_EMAIL'] is used.
  -s --secret=<secret>         Secret code.
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
