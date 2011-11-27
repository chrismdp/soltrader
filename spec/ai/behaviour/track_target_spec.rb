require 'spec_helper'

require 'core_ext/throttle'
require 'core_ext/radians'
require 'shared_examples/ai/behaviour'
require 'ai/behaviour/behaviour'
require 'ai/behaviour/track_target'

describe Spacestuff::Ai::Behaviour::TrackTarget do
  let(:ship) { double.as_null_object }
  let(:actor) { double(:actor, :current_target => nil, :ship => ship) }
  subject { Spacestuff::Ai::Behaviour::TrackTarget.new(:actor => actor) }

  it_behaves_like "a behaviour"

  it "has no priority if there's no target" do
    Spacestuff::Ai::Behaviour::TrackTarget.priority(actor).should == 0
  end

  it "has a priority if there is a target" do
    actor.should_receive(:current_target).and_return(double)
    Spacestuff::Ai::Behaviour::TrackTarget.priority(actor).should_not == 0
  end

  describe "update" do
    it "tracks left toward a target that is left of it" do
      ship.stub(:angle_to => -15.to_radians)

      ship.should_receive(:order).with(:turn_left)
      subject.update(100)
    end

    it "tracks right toward a target that is right of it" do
      ship.stub(:angle_to => 15.to_radians)

      ship.should_receive(:order).with(:turn_right)
      subject.update(100)
    end

    context "ship is facing target" do
      before do
        ship.stub(:angle_to => 1.to_radians)
      end
      it "moves close to a target it is facing" do
        ship.stub(:squared_distance_to => 300 ** 2)
        ship.should_receive(:order).with(:fire_main_engines)
        subject.update(100)
      end

      it "backs away from a target it is too close to" do
        ship.stub(:squared_distance_to => 50 ** 2)
        ship.should_receive(:order).with(:fire_reverse_engines)
        subject.update(100)
      end

      it "is done if we're between 250 and 75 of the target" do
        ship.stub(:squared_distance_to => 200 ** 2, :order => nil)
        subject.update(100).should == Spacestuff::Ai::Behaviour::DONE
      end
    end
  end
end
