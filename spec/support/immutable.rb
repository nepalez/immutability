# encoding: utf-8

# Checks whether the instance is truly (deeply) immutable
#
# @example
#   expect(instance).to be_immutable
#
# @api public
#
RSpec::Matchers.define :be_immutable do
  match do |instance|
    if instance && instance.class.respond_to?(:new)
      expect(instance).to be_frozen
      instance
        .instance_variables.map(&instance.method(:instance_variable_get))
        .each { |ivar| expect(ivar).to be_immutable }
    else
      expect(true).to be_truthy
    end
  end

  failure_message do |instance|
    "expected that #{instance.inspect} to be immutable"
  end
end
