# frozen_string_literal: true

ACTIONS = [0, 1, 2].product([true, false]).freeze

module SafePicker
  class Solver
    def solve(safe, path = [])
      current_state = safe.state
      current_path = path.empty? ? [current_state] : path
      safe.add_restricted_state(*current_state)

      prioritized_actions = ACTIONS.sort_by do |dial, clockwise|
        priority = turns_to_reach(
          current_state[dial],
          safe.opened_state[dial],
          clockwise
        )

        priority.zero? ? 10 : priority
      end

      prioritized_actions.each do |dial, clockwise|
        safe.state = current_state.clone
        if safe.rotate(dial, clockwise:)
          if safe.open?
            return current_path + [safe.state]
          else
            return solve(safe, current_path + [safe.state])
          end
        end
      end

      return false
    end

    private

    def turns_to_reach(from, to, clockwise)
      if (from <= to && clockwise) || (from >=to && !clockwise)
        (to - from).abs
      else
        10 - (to - from).abs
      end
    end
  end
end