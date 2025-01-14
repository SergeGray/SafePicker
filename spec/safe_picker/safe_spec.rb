# frozen_string_literal: true

require "spec_helper"

module SafePicker
  describe Safe do
    before(:each) do
      @safe = Safe.new
    end

    describe "#rotate" do
      it "rotates clockwise" do
        @safe.rotate(0)
        expect(@safe.state).to eq([1, 0, 0])
      end

      it "rotates counter clockwise" do
        @safe.rotate(1, clockwise: false)
        expect(@safe.state).to eq([0, 9, 0])
      end

      it "adjusts upper rotation overflow" do
        @safe.state = [9, 0, 0]
        @safe.rotate(0)
        expect(@safe.state).to eq([0, 0, 0])
      end

      it "adjusts lower rotation overflow" do
        @safe.rotate(0, clockwise: false)
        expect(@safe.state).to eq([9, 0, 0])
      end

      it "does not rotate to a restricted state" do
        @safe.restricted_states << [1, 0, 0]
        @safe.rotate(0)
        expect(@safe.state).to eq([0, 0, 0])
      end

      it "works with a larger safe" do
        safe = Safe.new(state: [0, 0, 0, 0, 0, 0])
        safe.rotate(5)
        expect(safe.state).to eq([0, 0, 0, 0, 0, 1])
      end

      it "works with a smaller safe" do
        safe = Safe.new(state: [0])
        safe.rotate(0)
        expect(safe.state).to eq([1])
      end
    end

    describe "#open?" do
      it "returns true if safe is open" do
        @safe.opened_state = [0, 0, 0]
        expect(@safe.open?).to be true
      end

      it "returns false if safe is not open" do
        @safe.opened_state = [0, 1, 0]
        expect(@safe.open?).to_not be true
      end
    end
  end
end
