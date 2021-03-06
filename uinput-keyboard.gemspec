# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uinput/keyboard/version'

Gem::Specification.new do |spec|
  spec.name          = "uinput-keyboard"
  spec.version       = Uinput::Keyboard::VERSION
  spec.authors       = ["Christopher Aue"]
  spec.email         = ["mail@christopheraue.net"]

  spec.summary       = %q{Ruby wrapper around uinput to create a virtual keyboard.}
  spec.homepage      = "https://github.com/christopheraue/ruby-uinput-keyboard"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "uinput-device", "~> 0.4"
  spec.add_dependency "xkbcommon", "~> 0.1"
  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
