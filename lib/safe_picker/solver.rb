# frozen_string_literal: true

ACTIONS = [0, 1, 2, 3, 4, 5].product([true, false]).freeze

module SafePicker
  class Solver
    def solve(safe, path = [])
      current_state = safe.state
      current_path = path.empty? ? [current_state] : path
      safe.add_restricted_state(*current_state)

      prioritized_actions(safe).each do |dial, clockwise|
        safe.state = current_state.clone
        if safe.rotate(dial, clockwise:)
          new_path = current_path + [safe.state]
          new_path = solve(safe, new_path) unless safe.open?
          return new_path if new_path
        end
      end

      return false
    end

    private

    def prioritized_actions(safe)
      ACTIONS.first(safe.lock_size * 2).sort_by do |dial, clockwise|
        priority =
          turns_to_reach(safe.state[dial], safe.opened_state[dial], clockwise)

        priority.zero? ? 10 : priority
      end
    end

    def turns_to_reach(from, to, clockwise)
      if (from <= to && clockwise) || (from >=to && !clockwise)
        (to - from).abs
      else
        10 - (to - from).abs
      end
    end
  end
end