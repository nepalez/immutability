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
    expect(instance).to be_frozen

    ivars = instance.instance_variables
    ivars.each { |ivar| expect(ivar).to be_immutable_part_of instance }
  end

  failure_message do |instance|
    "expected that #{instance.inspect} to be immutable"
  end
end

# Checks whether the variable is a truly immutable part of given instance
#
# @api private
#
RSpec::Matchers.define :be_immutable_part_of do |instance|
  match do |ivar|
    expect(ivar).to be_frozen
    ivar.instance_variables.each do |var|
      expect(var).to be_immutable_part_of instance
    end
  end

  failure_message do |ivar|
    object = instance.inspect
    "expected that #{ivar.inspect} to be frozen part of immutable #{object}"
  end
end
