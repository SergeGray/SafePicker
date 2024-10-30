# frozen_string_literal: true

module SafePicker
  class Safe
    attr_accessor :state

    def initialize(x, y, z)
      @state = [x, y, z]
    end

    def rotate(dial, clockwise: true)
      rotation = clockwise ? 1 : -1
      position = @state[dial]
      position += rotation
      @state[dial] = adjust_rotation(position)
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
  end
end
