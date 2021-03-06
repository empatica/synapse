# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "synapse"
  gem.version       = "0.12.1"
  gem.authors       = ["Martin Rhoads"]
  gem.email         = ["martin.rhoads@airbnb.com"]
  gem.description   = %q{: Write a gem description}
  gem.summary       = %q{: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_runtime_dependency "aws-sdk", "~> 2.0"
  gem.add_runtime_dependency "docker-api", '~> 1.7', '>= 1.7.2'
  #gem.add_runtime_dependency "aws-sdk-v1", "~> 1.39"
  #gem.add_runtime_dependency "docker-api", '~> 1.7', '>= 1.7.2'
  #gem.add_runtime_dependency 'zk', '~> 1.9', '>= 1.9.5'

  gem.add_development_dependency "rake", '~> 0'
  gem.add_development_dependency "rspec", '~> 3.1', '>= 3.1.0'
  gem.add_development_dependency "pry",  '~> 0'
  gem.add_development_dependency "pry-nav",  '~> 0'
end
