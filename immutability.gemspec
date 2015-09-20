$:.push File.expand_path("../lib", __FILE__)
require "immutability/version"

Gem::Specification.new do |gem|

  gem.name        = "immutability"
  gem.version     = Immutability::VERSION.dup
  gem.author      = "Andrew Kozin"
  gem.email       = "andrew.kozin@gmail.com"
  gem.homepage    = "https://github.com/nepalez/immutability"
  gem.summary     = "Make instances immutable (deeply frozen) and versioned"
  gem.license     = "MIT"

  gem.files            = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files       = Dir["spec/**/*.rb"]
  gem.extra_rdoc_files = Dir["README.md", "LICENSE"]
  gem.require_paths    = ["lib"]

  gem.required_ruby_version = ">= 1.9.3"

  gem.add_runtime_dependency "ice_nine", "~> 0.11.1"

  gem.add_development_dependency "hexx-rspec", "~> 0.5"

end # Gem::Specification
