$LOAD_PATH.unshift File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'toptranslation/version'

Gem::Specification.new do |s|
  s.name        = 'toptranslation_api'
  s.version     = Toptranslation::VERSION
  s.summary     = 'A ruby client for the Toptranslation API'
  s.description = 'Allows to create and control translation projects on Toptranslation via the Toptranslation API.'
  s.authors     = ['Toptranslation GmbH']
  s.email       = 'tech@toptranslation.com'
  s.files       = Dir['{lib}/**/*']
  s.homepage    = 'https://github.com/toptranslation/toptranslation_ruby'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.0.0'

  s.add_runtime_dependency 'json', '~> 2.0'
  s.add_runtime_dependency 'rest-client', '~> 2.0'
  s.add_development_dependency 'pry', '~> 0.11'
  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'vcr', '~> 4.0'
  s.add_development_dependency 'webmock', '~> 3.4'
  s.metadata['rubygems_mfa_required'] = 'true'
end
