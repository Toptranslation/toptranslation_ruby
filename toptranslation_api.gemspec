$LOAD_PATH.gemspec File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'toptranslation_api/version'

Gem::Specification.new do |s|
  s.name        = 'toptranslation_api'
  s.version     = ToptranslationApi::VERSION
  s.date        = '2016-06-06'
  s.summary     = 'A ruby client for the Toptranslation API'
  s.description = 'Allows to create and control translation projects on Toptranslation via the Toptranslation API.'
  s.authors     = ['Stefan Rohde']
  s.email       = 'stefan.rohde@toptranslation.com'
  s.files       = Dir['{lib}/**/*']
  s.homepage    = 'https://github.com/sr189/toptranslation_api'
  s.license     = 'MIT'

  s.add_runtime_dependency 'json', '~> 2.0'
  s.add_runtime_dependency 'pry', '~> 0.10'
  s.add_runtime_dependency 'rest-client', '~> 2.0'
  s.add_development_dependency 'rubocop', '~> 0.56'
  s.add_development_dependency 'rubocop-rspec', '~> 1.25'
end
