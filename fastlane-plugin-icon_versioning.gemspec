lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/icon_versioning/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-icon_versioning'
  spec.version       = Fastlane::IconVersioning::VERSION
  spec.author        = 'Iulian Onofrei'
  spec.email         = '6d0847b9@opayq.com'

  spec.summary       = 'Overlay build information on top of your app icon'
  spec.homepage      = 'https://github.com/revolter/fastlane-plugin-icon_versioning'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*'] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  spec.add_dependency('mini_magick', '>= 4.5.1')

  spec.add_development_dependency('bundler', '>= 1.12.0')
  spec.add_development_dependency('coveralls', '~> 0.7.2')
  spec.add_development_dependency('fastlane', '>= 2.89.0')
  spec.add_development_dependency('pry', '~> 0.11.3')
  spec.add_development_dependency('rake', '~> 12.3.1')
  spec.add_development_dependency('rspec', '~> 3.7.0')
  spec.add_development_dependency('rspec_junit_formatter', '~> 0.3.0')
  spec.add_development_dependency('rubocop', '~> 0.54.0')
  spec.add_development_dependency('rubocop-require_tools', '~> 0.1.2')
  spec.add_development_dependency('simplecov', '~> 0.16.1')
end
