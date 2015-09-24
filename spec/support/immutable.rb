# encoding: utf-8

# Checks whether the instance is truly (deeply) immutable
#
# @example
#   expect(instance).to be_immutable
#
# @api public
#
RSpec::Matchers.define :be_immutable do
  def can_be_frozen?(value)
    return false if value.is_a? Module
    return false if value.nil?
    return false if value.equal? true
    return false if value.equal? false
    return false if !value.class.respond_to?(:new)
    true
  end

  match do |instance|
    if can_be_frozen? instance
      expect(instance).to be_frozen
    end

    if instance.is_a? Hash
      instance.each do |k, v|
        expect(k).to be_immutable
        expect(v).to be_immutable
      end
    else
      instance.instance_variables.each do |ivar|
        expect(instance.instance_variable_get(ivar)).to be_immutable
      end

      if instance.respond_to? :each
        instance.each { |item| expect(item).to be_immutable }
      end
    end

    expect(true).to be_truthy
  end

  failure_message do |instance|
    "expected that #{instance.inspect} to be immutable"
  end
end
