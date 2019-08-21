require File.expand_path('lib/enum_type/version', __dir__)

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
  s.required_ruby_version = '>= 2.5.0'
  s.add_runtime_dependency 'dry-types', '> 0.6'
  s.add_development_dependency 'byebug', '> 9.0.6'
  s.add_development_dependency 'pry', '> 0.10.4'
  s.add_development_dependency 'rspec', '> 3.6'
  s.add_development_dependency 'rubocop', '> 0.71.0'
  # lol - required for validation
  s.rubyforge_project = 'enum-type'
end
