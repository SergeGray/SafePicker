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
        expect(Solver.new(@safe).solve).to eq(
          [[0, 0, 0], [1, 0, 0,], [1, 1, 0], [1, 1, 1]]
        )
      end

      it "does not use restricted states" do
        @safe.opened_state = [1, 1, 1]
        @safe.restricted_states << [1, 0, 0]
        expect(Solver.new(@safe).solve).to eq(
          [[0, 0, 0], [0, 1, 0,], [1, 1, 0], [1, 1, 1]]
        )
      end
      
      it "doubles back upon encountering a dead end" do
        @safe.opened_state = [2, 2, 2]
        restricted_states = [[2, 1, 0], [2, 0, 1], [2, 9, 0], [2, 0, 9]]
        @safe.restricted_states = restricted_states.clone

        solution = Solver.new(@safe).solve
        expect(solution).to include([3, 0, 0])
        restricted_states.each do |state|
          expect(solution).to_not include state
        end
      end
      
      it "doesn't fail if there's no valid moves on one branch" do
        @safe.opened_state = [2, 2, 2]
        restricted_states = [[2, 1, 0], [2, 0, 1], [2, 9, 0], [2, 0, 9], [3, 0, 0]]
        @safe.restricted_states = restricted_states.clone

        solution = Solver.new(@safe).solve
        expect(solution).to_not be false
        restricted_states.each do |state|
          expect(solution).to_not include state
        end
      end

      it "fails if there's no valid moves" do
        @safe.opened_state = [1, 1, 1]
        restricted_states = [[1, 0, 0], [0, 1, 0], [0, 0, 1], [9, 0, 0], [0, 9, 0], [0, 0, 9]]
        @safe.restricted_states = restricted_states.clone

        expect(Solver.new(@safe).solve).to be false
      end

      it "Works with a larger safe" do
        safe = Safe.new(0, 0, 0, 0, 0, 0)
        safe.opened_state = [1, 1, 1, 1, 1, 1]
        safe.restricted_states << [1, 1, 1, 1, 1, 0]

        solution = Solver.new(safe).solve
        expect(solution).to_not be false
        expect(solution).to_not include([1, 1, 1, 1, 1, 0])
      end

      it "Works with a smaller safe" do
        safe = Safe.new(0)
        safe.opened_state = [2]
        safe.restricted_states << [1]

        solution = Solver.new(safe).solve
        expect(solution).to_not be false
        expect(solution).to_not include([1])
      end
    end
  end
end