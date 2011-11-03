require 'spec_gosu'

describe Spacestuff::Graphics::Ship do
  let(:location) { double(:location, :x => 1, :y => 1) }
  let(:ship) { double(:ship, :location => location, :pieces => [], :size => [4,4]).as_null_object }

  context "with a passed in ship" do
    subject { Spacestuff::Graphics::Ship.create(ship) }

    it "delegates engine activity" do
      ship.should_receive(:fire_main_engines).at_least(1).times.and_return([1,2])
      subject.go_faster
      subject.velocity_x.should == 1
      subject.velocity_y.should == 2

      ship.should_receive(:fire_reverse_engines).at_least(1).times.and_return([0,1])
      subject.go_slower
      subject.velocity_x.should == 0
      subject.velocity_y.should == 1
    end

    it "takes position from the logical ship's position" do
      subject.x.should == ship.location.x
      subject.y.should == ship.location.y
    end

    it "turning should ask the ship to turn" do
      ship.should_receive(:turn_left).and_return(42)
      subject.turn_left
      subject.angle.should == 42
    end

    it "turning should ask the ship to turn" do
      ship.should_receive(:turn_right).and_return(42)
      subject.turn_right
      subject.angle.should == 42
    end
  end

end
