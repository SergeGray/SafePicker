# frozen_string_literal: true

module SafePicker
  class Safe
    attr_accessor :state
    attr_accessor :opened_state
    attr_reader :restricted_states

    def initialize(x, y, z)
      @state = [x, y, z]
      @restricted_states = []
    end

    def add_restricted_state(x, y, z)
      @restricted_states << [x, y, z]
    end

    def rotate(dial, clockwise: true)
      rotation = clockwise ? 1 : -1
      position = @state[dial]
      position = adjust_rotation(position + rotation)

      rotate_if_not_restricted(dial, position)
    end

    def open?
      @state == @opened_state
    end

    private

    def adjust_rotation(value)
      if value > 9
        0
      elsif value < 0
        9
      else
        value
      end
    end

    def rotate_if_not_restricted(dial, position)
      initial_position = @state[dial]
      @state[dial] = position
      if @restricted_states.include?(@state)
        @state[dial] = initial_position
        return false
      end

      @state
    end
  end
end