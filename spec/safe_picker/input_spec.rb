# frozen_string_literal: true

require "spec_helper"

module SafePicker
  describe Input do
    describe "#execute" do
      it "accepts user input and returns solution" do
        input = Input.new
        start = [1, 1, 1]
        opened = [2, 2, 2]
        solution = [[2, 1, 1], [2, 2, 1], [2, 2, 2]]
        
        allow_any_instance_of(TerminalInterface).to receive(:get_current_state).and_return(start)
        allow_any_instance_of(TerminalInterface).to receive(:get_opened_state).and_return(opened)
        allow_any_instance_of(TerminalInterface).to receive(:get_restricted_states).and_return([])
        allow_any_instance_of(Solver).to receive(:solve).and_return(solution)

        expect_any_instance_of(TerminalInterface).to receive(:post_solution).with(solution)
        input.execute
      end
    end
  end
end