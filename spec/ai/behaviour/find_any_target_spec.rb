require 'spec_helper'

require 'shared_examples/ai/behaviour'
require 'ai/behaviour/behaviour'
require 'ai/behaviour/find_any_target'

require 'core_ext/throttle'

describe Spacestuff::Ai::Behaviour::FindAnyTarget do
  let(:ship) { double }
  let(:actor) { double(:actor, :ship => ship, :current_target => nil) }
  subject { Spacestuff::Ai::Behaviour::FindAnyTarget.new(:actor => actor) }

  it_behaves_like "a behaviour"

  context "priority" do
    def priority
      Spacestuff::Ai::Behaviour::FindAnyTarget.priority(actor)
    end

    it "if the actor isn't on a ship, there is no priority" do
      actor.stub(:ship => nil)
      priority.should == 0
    end

    it "has a priority if there's no target" do
      priority.should_not == 0
    end

    it "has no priority if there is a target" do
      actor.should_receive(:current_target).twice.and_return(double(:dead? => false))
      priority.should == 0
    end

    it "has a priority if the current target is dead" do
      actor.should_receive(:current_target).twice.and_return(double(:dead? => true))
      priority.should == 100
    end
  end

  context "updating" do
    it "scans for a ship" do
      actor.should_receive(:acquire_target)
      subject.update(1)
    end

    it "only scans once in a while" do
      actor.should_receive(:acquire_target).once
      subject.update(1)
      subject.update(1)
    end

    it "is done when we've found a target" do
      actor.stub(:acquire_target)
      actor.stub(:current_target => double)
      subject.update(1).should == Spacestuff::Ai::Behaviour::DONE
    end
  end
end
