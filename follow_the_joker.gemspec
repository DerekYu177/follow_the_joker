# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'follow_the_joker/version'

Gem::Specification.new do |s|
  s.name          = 'follow_the_joker'
  s.version       = FollowTheJoker::VERSION
  s.summary       = 'A game engine for the popular game 大怪路子.'
  s.description   = 'A game engine for the popular game 大怪路子.'
  s.authors       = ['Derek Yu']
  s.email         = 'derek-nis@hotmail.com'
  s.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  s.homepage      = 'https://github.com/DerekYu177/follow_the_joker'
  s.license       = 'MIT'
  s.require_paths = ['lib']

  s.add_runtime_dependency 'activesupport', '~> 7.0.4'
  s.add_runtime_dependency 'cli', '~> 1.4.0'

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'factory_bot', '~> 6.2.1'
  s.add_development_dependency 'pry', '~> 0.14.1'
  s.add_development_dependency 'pry-byebug', '~> 3.10.1'
  s.add_development_dependency 'rspec-core', '~> 3.12.0'
  s.add_development_dependency 'rspec-expectations', '~> 3.12.0'
  s.add_development_dependency 'rspec-mocks', '~> 3.12.0'
  s.required_ruby_version = '>= 3.0.2'
end
