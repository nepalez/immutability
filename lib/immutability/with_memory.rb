# encoding: utf-8

module Immutability

  # Extends +Immutability+ to remember version and previous state of instance.
  #
  # @author Andrew Kozin <Andrew.Kozin@gmail.com>
  #
  module WithMemory

    include Immutability

    # Methods to be added to class, that included the `Immutability` module
    #
    # @api private
    #
    module ClassMethods

      # Reloads instance's constructor to add version and parent and make
      # the whole instance immutable
      #
      # @api private
      #
      # @param [Object, Array<Object>] args
      # @param [Proc] block
      #
      # @return [Object]
      #
      def new(*args, &block)
        instance = allocate.tap do |obj|
          obj.__send__(:initialize, *args, &block)
          obj.instance_variable_set(:@version, 0)
          obj.instance_variable_set(:@parent, nil)
        end
        IceNine.deep_freeze(instance)
      end

    end # module ClassMethods

    # @!attribute [r] version
    #
    # @return [Integer] the current version number of the instance
    #
    attr_reader :version

    # @!attribute [r] parent
    #
    # @return [Object] the previous version (immutable instance)
    #
    attr_reader :parent

    # Redefines the +update+ so that it increment version and refer
    # to the previous snapshot of the continuous object
    #
    # @param [Proc] block
    #
    def update(&block)
      current = [version + 1, self]
      super do
        @version, @parent = current
        instance_eval(&block) if block
      end
    end

    # Forgets the previous history of the object
    #
    # Returns a new instance with the same variables,
    # except for [#version] and [#parent] that are set to +0+ and +nil+.
    #
    # @return [Object]
    #
    def forget_history
      update { @version, @parent = 0 }
    end

    # Returns an ancestor of the instance at some point in the past
    #
    # @param [#to_i] point
    #   Either a positive number of version, or a negative number of versions
    #   (snapshots) before now. +0+ stands for the first version.
    #
    # @return [Object, nil]
    #
    def at(point)
      Object.new(self).at(point)
    end

    # @private
    def self.included(klass)
      klass.instance_eval { extend ClassMethods }
    end

  end # module WithMemory

end # module Immutability
