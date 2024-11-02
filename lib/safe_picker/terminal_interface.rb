# frozen_string_literal: true

module SafePicker
  class TerminalInterface
    def get_current_state
      get_state("Enter current safe state")
    end

    def get_opened_state
      get_state("Enter opened safe state")
    end

    def get_restricted_states
      first = true
      puts("Keep entering restricted states, enter nothing to continue")
      restricted_states = []
      input = nil
      restricted_states << input while (input = get_state)
      restricted_states
    end

    def post_solution(solution)
      if solution
        puts "Path to solving the safe is:"
        solution.each { |state| p(state) }
      else
        puts "Safe is impossible to solve"
      end
    end

    private

    def get_state(message = nil)
      puts(message) if message
      input = gets.chomp
      return if input.empty?

      input.split(/,\s*/).map(&:to_i)
    end
  end
end