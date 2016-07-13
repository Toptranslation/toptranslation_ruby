$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "toptranslation/version"

Gem::Specification.new do |s|
  s.name        = 'toptranslation'
  s.version     = Toptranslation::VERSION
  s.date        = '2016-06-06'
  s.summary     = "A ruby client for the Toptranslation API"
  s.description = "Allows to create and control translation projects on Toptranslation via the Toptranslation API."
  s.authors     = ["Stefan Rohde"]
  s.email       = 'info@rohdenetz.de'
  s.files       = Dir["{lib}/**/*"]
  s.homepage    =
    'https://github.com/sr189/toptranslation'
  s.license       = 'MIT'

  s.add_runtime_dependency 'rest-client', '~> 1.8'
  s.add_dependency 'httmultiparty', '~> 0.3.16'
  s.add_runtime_dependency 'pry', '~> 0.10'
end
