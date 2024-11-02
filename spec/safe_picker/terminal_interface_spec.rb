# frozen_string_literal: true

require "spec_helper"

module SafePicker
  describe TerminalInterface do
    before(:each) do
      @interface = TerminalInterface.new
    end

    describe "#get_current_state" do
      it "accepts current state" do
        allow(@interface).to receive(:gets).and_return("1, 2, 3\n")

        expect(@interface.get_current_state).to eq([1, 2, 3])
      end
    end

    describe "#get_opened_state" do
      it "accepts opened state" do
        allow(@interface).to receive(:gets).and_return("1, 2, 3\n")

        expect(@interface.get_opened_state).to eq([1, 2, 3])
      end
    end

    describe "#get_restricted_state" do
      it "accepts restricted states until empty input is received" do
        allow(@interface).to receive(:gets).and_return("1, 2, 3\n", "4, 5, 6\n", "\n")

        expect(@interface.get_restricted_states).to eq([[1, 2, 3], [4, 5, 6]])
      end
    end

    describe "#post_solution" do
      it "returns the solution" do
        solution = [[1, 2, 3], [4, 5, 6]]
        expect { @interface.post_solution(solution) }.to output(
          "Path to solving the safe is:\n"\
          "[1, 2, 3]\n"\
          "[4, 5, 6]\n"
        ).to_stdout
      end
    end
  end
end