# encoding: utf-8

begin
  require "hexx-suit"
  Hexx::Suit.load_metrics_for(self)
rescue LoadError
  require "hexx-rspec"
  Hexx::RSpec.load_metrics_for(self)
end

# Loads the code under test
require "immutability"

# Loads custom matchers
require "immutability/rspec"

# Loads shared examples
require_relative "shared/user"

# @todo Remove after resolving of mutant PR#444
# @see https://github.com/mbj/mutant/issues/444
if ENV["MUTANT"]
  RSpec.configure do |config|
    config.around { |example| Timeout.timeout(0.5, &example) }
  end
end
