# encoding: utf-8

module Immutability

  # Extends +Immutability+ to remember version and previous state of instance.
  #
  # @author Andrew Kozin <Andrew.Kozin@gmail.com>
  #
  module WithMemory

    # @private
    class << self
      private

      def included(klass)
        klass.__send__ :include, Immutability
        klass.__send__ :extend,  ClassMethods
        klass.__send__ :define_method, :update, update
      end

      # Redefines the +update+ so that it increment version and refer
      # to the previous snapshot of the continuous object
      #
      def update
        proc do |&block|
          current = [(version + 1), self]
          super() do
            @version, @parent = current
            instance_eval(&block) if block
          end
        end
      end
    end

    # Adds version and parent variables to newly created instance
    #
    module ClassMethods
      private

      def __new__(*args)
        super(*args) { @version, @parent = 0 }
      end
    end

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

  end # module WithMemory

end # module Immutability
