# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json_data/version'

Gem::Specification.new do |spec|
  spec.name          = 'json_data'
  spec.version       = JSONData::VERSION
  spec.authors       = ['Jay Zheng']
  spec.email         = ['jay.j.zheng@gmail.com']

  spec.summary       = 'a super simple DSL to deal with JSON Data'
  spec.homepage      = 'https://github.com/jayjzheng/json_data'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.8', '>= 5.8.2'
  spec.add_development_dependency 'simplecov', '~> 0.9.2'
end
