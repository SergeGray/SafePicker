# frozen_string_literal: true

require "spec_helper"

module SafePicker
  describe Solver do
    describe "#solve" do
      before(:each) do
        @safe = Safe.new(0, 0, 0)
      end

      it "returns solution to safe" do
        @safe.opened_state = [1, 1, 1]
        expect(Solver.new.solve(@safe)).to eq(
          [[0, 0, 0], [1, 0, 0,], [1, 1, 0], [1, 1, 1]]
        )
      end

      it "does not use restricted states" do
        @safe.opened_state = [1, 1, 1]
        @safe.add_restricted_state(1, 0, 0)
        expect(Solver.new.solve(@safe)).to eq(
          [[0, 0, 0], [0, 1, 0,], [1, 1, 0], [1, 1, 1]]
        )
      end
      
      it "doubles back upon encountering a dead end" do
        @safe.opened_state = [2, 2, 2]
        restricted_states = [[2, 1, 0], [2, 0, 1], [2, 9, 0], [2, 0, 9]]
        restricted_states.each do |state|
          @safe.add_restricted_state(*state)
        end

        expect(Solver.new.solve(@safe)).to include([3, 0, 0])
      end
      
      it "doesn't fail if there's no valid moves on one branch" do
        @safe.opened_state = [2, 2, 2]
        restricted_states = [[2, 1, 0], [2, 0, 1], [2, 9, 0], [2, 0, 9], [3, 0, 0]]
        restricted_states.each do |state|
          @safe.add_restricted_state(*state)
        end

        expect(Solver.new.solve(@safe)).to_not be false
      end

      it "fails if there's no valid moves" do
        @safe.opened_state = [1, 1, 1]
        restricted_states = [[1, 0, 0], [0, 1, 0], [0, 0, 1], [9, 0, 0], [0, 9, 0], [0, 0, 9]]
        restricted_states.each do |state|
          @safe.add_restricted_state(*state)
        end

        expect(Solver.new.solve(@safe)).to be false
      end

      it "Works with a larger safe" do
        safe = Safe.new(0, 0, 0, 0, 0, 0)
        safe.opened_state = [1, 1, 1, 1, 1, 1]
        safe.add_restricted_state(1, 1, 1, 1, 1, 0)

        expect(Solver.new.solve(safe)).to_not be false
      end

      it "Works with a smaller safe" do
        safe = Safe.new(0)
        safe.opened_state = [2]
        safe.add_restricted_state(1)

        expect(Solver.new.solve(safe)).to_not be false
      end
    end
  end
end