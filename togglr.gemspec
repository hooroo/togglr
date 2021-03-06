lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'togglr/version'

Gem::Specification.new do |spec|
  spec.name          = 'togglr'
  spec.version       = Togglr::VERSION
  spec.authors       = ['Brett Wilkins', 'Michal Pisanko']
  spec.email         = ['brett@hooroo.com', 'michal@hooroo.com']
  spec.description   = %q{Our very own feature toggling implementation}
  spec.summary       = %q{Our very own feature toggling implementation}
  spec.homepage      = 'https://github.com/hooroo/togglr'
  spec.license       = ''

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'pry', '~> 0.9'
  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'sqlite3', '~> 1.3.8'
  spec.add_development_dependency 'activerecord', '~> 4.1.9'
end
