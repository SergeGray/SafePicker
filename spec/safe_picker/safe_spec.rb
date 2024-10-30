# frozen_string_literal: true

require "spec_helper"

module SafePicker
  describe Safe do
    describe "#rotate" do
      it "rotates clockwise" do
        safe = Safe.new(0, 0, 0)
        safe.rotate(0)
        expect(safe.state).to eq([1, 0, 0])
      end

      it "rotates counter clockwise" do
        safe = Safe.new(0, 0, 0)
        safe.rotate(1, clockwise: false)
        expect(safe.state).to eq([0, 9, 0])
      end

      it "adjusts upper rotation overflow" do
        safe = Safe.new(9, 0, 0)
        safe.rotate(0)
        expect(safe.state).to eq([0, 0, 0])
      end

      it "adjusts lower rotation overflow" do
        safe = Safe.new(0, 0, 0)
        safe.rotate(0, clockwise: false)
        expect(safe.state).to eq([9, 0, 0])
      end
    end
  end
end
