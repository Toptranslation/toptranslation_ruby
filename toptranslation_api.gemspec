$LOAD_PATH.unshift File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'toptranslation/version'

Gem::Specification.new do |s|
  s.name        = 'toptranslation_api'
  s.version     = ToptranslationApi::VERSION
  s.summary     = 'A ruby client for the Toptranslation API'
  s.description = 'Allows to create and control translation projects on Toptranslation via the Toptranslation API.'
  s.authors     = ['Toptranslation GmbH']
  s.email       = 'tech@toptranslation.com'
  s.files       = Dir['{lib}/**/*']
  s.homepage    = 'https://github.com/toptranslation/toptranslation_ruby'
  s.license     = 'MIT'

  s.add_runtime_dependency 'json', '~> 2.0'
  s.add_runtime_dependency 'rest-client', '~> 2.0'
  s.add_development_dependency 'pry', '~> 0.11'
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'rubocop', '~> 0.56.0'
  s.add_development_dependency 'rubocop-rspec', '~> 1.25.1'
  s.add_development_dependency 'webmock', '~> 3.4'
end
