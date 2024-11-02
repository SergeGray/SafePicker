# frozen_string_literal: true

module SafePicker
  class Input
    def initialize(interface: TerminalInterface.new)
      @interface = interface
      @safe = Safe.new
      @solver = Solver.new(@safe)
    end

    def execute
      @safe.state = @interface.get_current_state
      @safe.opened_state = @interface.get_opened_state
      @safe.restricted_states = @interface.get_restricted_states

      @interface.post_solution(@solver.solve)
    end
  end
end
