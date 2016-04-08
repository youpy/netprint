# -*- encoding: utf-8 -*-
require File.expand_path('../lib/netprint/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["youpy"]
  gem.email         = ["youpy@buycheapviagraonlinenow.com"]
  gem.description   = %q{A library to upload file to netprint}
  gem.summary       = %q{A library to upload file to netprint}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files -z`.split("\0")
  gem.test_files    = `git ls-files -z -- {test,spec,features}/*`.split("\0")
  gem.name          = "netprint"
  gem.require_paths = ["lib"]
  gem.version       = Netprint::VERSION

  gem.add_development_dependency('rspec', ['~> 2.8.0'])
  gem.add_development_dependency('rake')
  gem.add_development_dependency('webmock')
  gem.add_dependency('mechanize', '2.7.0')
  gem.add_dependency('docopt')
end
