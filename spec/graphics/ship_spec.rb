require 'spec_gosu'

describe Spacestuff::Graphics::Ship do
  let(:ship) { double(:ship, :x => 1, :y => 2, :pieces => [], :size => [4,4]).as_null_object }

  context "with a passed in ship" do
    subject { Spacestuff::Graphics::Ship.create(ship) }

    it "takes position from the logical ship's position" do
      subject.x.should == ship.x
      subject.y.should == ship.y
    end

    it "starts listening to entity events" do
      ship.should_receive(:listen).exactly(3).times
      Spacestuff::Graphics::Ship.create(ship)
    end
  end

end
