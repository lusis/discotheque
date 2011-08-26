$:.push File.expand_path("../lib", __FILE__)
require 'discotheque/version'

Gem::Specification.new do |s|
  s.name        = "discotheque"
  s.version     = Discotheque::VERSION
  s.authors     = ["John E. Vincent"]
  s.email       = ["lusis.org+github.com@gmail.com"]

  s.summary     = "Framework for node discovery"
  s.description = "Adds functionality to your application for node discovery using Amazon EC2"
  s.homepage    = "https://github.com/lusis/discotheque"
  s.files       = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency("aws-sdk", "= 1.1.2")
  s.add_dependency("rake", "= 0.9.2")

end
