# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'follow_the_joker/version'

Gem::Specification.new do |s|
  s.name          = "follow_the_joker"
  s.version       = FollowTheJoker::VERSION
  s.summary       = "A game engine for the popular game 大怪路子."
  s.description   = "A game engine for the popular game 大怪路子."
  s.authors       = ["Derek Yu"]
  s.email         = "derek-nis@hotmail.com"
  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.homepage      = ""
  s.license       = "MIT"

  s.add_development_dependency "bundler", "~> 2.0"
  # s.add_development_dependency "pry"
  s.add_development_dependency "pry-byebug"
  s.required_ruby_version = ">= 3.0.2"
end
