# frozen_string_literal: true

require "spec_helper"

module SafePicker
  describe Solver do
    describe "#solve" do
      it "returns solution to safe" do
        safe = Safe.new(0, 0, 0)
        safe.opened_state = [1, 1, 1]
        expect(Solver.new.solve(safe)).to eq(
          [[0, 0, 0], [1, 0, 0,], [1, 1, 0], [1, 1, 1]]
        )
      end

      it "does not use restricted states" do
        safe = Safe.new(0, 0, 0)
        safe.opened_state = [1, 1, 1]
        safe.add_restricted_state(1, 0, 0)
        expect(Solver.new.solve(safe)).to eq(
          [[0, 0, 0], [0, 1, 0,], [1, 1, 0], [1, 1, 1]]
        )
      end
    end
  end
end