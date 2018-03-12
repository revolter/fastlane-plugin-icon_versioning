# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
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

  spec.add_dependency('mini_magick')

  spec.add_development_dependency('pry')
  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rubocop', '0.49.1')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('fastlane', '>= 2.84.0')
  spec.add_development_dependency('coveralls')
end
