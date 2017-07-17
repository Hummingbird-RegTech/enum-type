require File.expand_path('../lib/enum_type/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'enum-type'
  s.version      = EnumType::VERSION
  s.date         = EnumType::VERSION_DATE
  s.platform     = Gem::Platform::RUBY
  s.summary      = 'A Java inspired, typesafe enum implementation in Ruby.'
  s.description  = 'A Java inspired, typesafe enum implementation in Ruby.'
  s.authors      = ['Jesse Reiss']
  s.email        = 'jesse@37c.io'
  s.files        = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE', '*.md']
  s.require_path = 'lib'
  s.homepage     = 'https://github.com/thegorgon/enum-type'
  s.license      = 'MIT'
  # lol - required for validation
  s.rubyforge_project = 'enum-type'
end
