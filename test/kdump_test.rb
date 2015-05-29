#!/usr/bin/env rspec

require_relative "./test_helper"

include Yast
Yast.import "Kdump"

describe Kdump do
  # allocated_memory is a string   in megabytes
  # total_memory     is an integer in megabytes
  describe "#ProposeAllocatedMemory" do
    context "when already proposed" do
      before(:each) do
        Kdump.allocated_memory = "42"
      end
      it "proposes the current value" do
        Kdump.ProposeAllocatedMemory
        expect(Kdump.allocated_memory).to eq "42"
      end
    end

    context "when not yet proposed" do
      before(:each) do
        Kdump.allocated_memory = "0"
      end

      context "when the proposal tool is not implemented yet" do
        before(:each) do
          SCR.stub(:Execute).
            with(path(".target.bash"), /^cp/).and_return(0)
          SCR.stub(:Execute).
            with(path(".target.bash_output"), /^kdumptool/).
            and_return({"exit" => 1, "stdout" => "", "stderr" => "not there" })
        end

        it "proposes a positive integer" do
          Kdump.ProposeAllocatedMemory
          expect(Kdump.allocated_memory.to_i).to be > 0
        end
      end
    end
  end
end
