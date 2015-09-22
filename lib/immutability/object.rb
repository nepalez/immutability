# encoding: utf-8
module Immutability

  # Describes the continuous object as a sequence of immutable snapshots
  # with an option of searching the past state of the object
  #
  # @api private
  #
  # @author Andrew Kozin <Andrew.Kozin@gmail.com>
  #
  class Object

    include Enumerable

    # Initializes the object from the current state (snapshot)
    #
    # @param [#version, #parent] current
    #
    def initialize(current)
      @current = current
    end

    # The current (last) version of the object
    #
    # The object knows nothing about its future
    #
    # @return [Integer]
    #
    def version
      @current.version
    end

    # Iterates via object's snapshots from the current state to the past
    #
    # @return [Enumerator]
    #
    def each
      return to_enum unless block_given?
      state = @current
      while state
        yield(state)
        state = state.parent
      end
    end

    # Returns the state of the object at some point in the past
    #
    # @param [#to_i] point
    #   Either a positive number of target version,
    #   or a negative number of version (snapshots) before the current one
    #   +0+ stands for the first version.
    #
    # @return [Object, nil]
    #
    def at(point)
      ipoint = point.to_i
      target = (ipoint < 0) ? (version + ipoint) : ipoint
      return unless (0..version).include? target

      detect { |state| target.equal? state.version }
    end

  end # class Object

end # module Immutability
