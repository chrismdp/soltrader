require 'spec_gosu'

describe Spacestuff::Graphics::Ship do
  let(:location) { double(:location, :x => 1, :y => 1) }
  let(:ship) { double(:ship, :location => location, :pieces => [], :size => [4,4]) }

  context "with a passed in ship" do
    subject { Spacestuff::Graphics::Ship.create(ship) }

    it "delegates engine indicators" do
      ship.should_receive(:rate_of_acceleration).at_least(1).times.and_return(0)
      subject.go_faster
      ship.should_receive(:rate_of_braking).at_least(1).times.and_return(0)
      subject.go_slower
    end

    it "takes position from the logical ship's position" do
      subject.x.should == ship.location.x
      subject.y.should == ship.location.y
    end
  end

end
