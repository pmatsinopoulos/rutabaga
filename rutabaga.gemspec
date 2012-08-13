# coding: utf-8
require File.expand_path('../lib/rutabaga/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Lukas Oberhuber']
  gem.email         = ['lukas.oberhuber@simplybusiness.co.uk']
  gem.description   = %q{Allows using feature from within RSpec and is built on top of Turnip}
  gem.summary       = %q{Calling feature files from Turnip}
  gem.homepage      = ''

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = 'rutabaga'
  gem.require_paths = ['lib']
  gem.version       = Rutabaga::VERSION
  gem.license       = 'MIT'

  gem.add_runtime_dependency 'turnip',     '>= 1.0.0'
end