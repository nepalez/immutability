# encoding: utf-8

require "ice_nine"

# Makes the object immutable (deeply frozen) with possibility to remember
# and forget previous states (snapshots).
#
# Uses 'ice_nine' to freeze object deeply by the initializer
#
# @example Without memory
#   require "immutability"
#
#   class User
#     include Immutability
#
#     attr_reader :name
#
#     def initialize(name)
#       @name = name
#     end
#   end
#
#   user = User.new "Andre"
#   user.name             # => "Andre"
#   # It is frozen deeply
#   user.frozen?          # => true
#   user.name.frozen?     # => true
#
#   new_user = user.update { @name = "Andrew" }
#   new_user.name         # => "Andrew"
#   # It is frozen deeply
#   new_user.frozen?      # => true
#   new_user.name.frozen? # => true
#
# @example With memory
#   class User
#     include Immutability.with_memory
#
#     attr_reader :name
#
#     def initialize(name)
#       @name = name
#     end
#   end
#
#   user = User.new "Andre"
#   user.name             # => "Andre"
#   # It has version and reference to the parent (nil for the first version)
#   user.version          # => 0
#   user.parent           # => nil
#
#   new_user = user.update { @name = "Andrew" }
#   new_user.name         # => "Andrew"
#   # It stores current version and reference to the parent
#   new_user.version      # => 1
#   new_user.parent       # => #<User @name="Andre">
#
#   mankurt = new_user.forget_history
#   mankurt.name          # => "Andrew"
#   # It doesn't refer to previous states (they can be garbage collected)
#   mankurt.version       # => 0
#   mankurt.parent        # => nil
#
# @author Andrew Kozin <Andrew.Kozin@gmail.com>
#
module Immutability

  # Methods to be added to class, that included the `Immutability` module
  #
  # @api private
  #
  module ClassMethods

    # Reloads instance's constructor to make it immutable
    #
    # @api private
    #
    # @param [Object, Array<Object>] args
    #
    # @return [Object]
    #
    def new(*args)
      IceNine.deep_freeze __new__(*args)
    end

    private

    def __new__(*args, &block)
      allocate.tap do |instance|
        instance.__send__(:initialize, *args)
        instance.instance_eval(&block) if block_given?
      end
    end

  end # module ClassMethods

  # @private
  def self.included(klass)
    klass.instance_exec(ClassMethods) { |mod| extend(mod) }
  end

  # Returns the new immutable instances that preserves old variables and
  # updates some of them from inside the block
  #
  # @param [Proc] block
  #   The block to be evaluated by new instance's "initializer"
  #
  # @return [Object] the updated instance
  #
  def update(&block)
    instance = dup
    instance.instance_eval(&block) if block_given?
    IceNine.deep_freeze(instance)
  end

end # module Immutability
