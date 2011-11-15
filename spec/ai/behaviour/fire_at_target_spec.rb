require 'spec_helper'

require 'shared_examples/ai/behaviour'
require 'ai/behaviour/behaviour'
require 'ai/behaviour/fire_at_target'

describe Spacestuff::Ai::Behaviour::FireAtTarget do
  let(:ship) { double }
  let(:actor) { double(:actor, :ship => ship, :current_target => nil) }
  subject { Spacestuff::Ai::Behaviour::FireAtTarget.new(:actor => actor) }

  it_behaves_like "a behaviour"

  it "has no priority if there's no target" do
    Spacestuff::Ai::Behaviour::FireAtTarget.priority(actor).should == 0
  end
  it "has no priority if there's no ship" do
    actor.stub(:ship => nil)
    Spacestuff::Ai::Behaviour::FireAtTarget.priority(actor).should == 0
  end

  it "has a priority if there is a target and we're close to it" do
    actor.should_receive(:current_target).and_return(double)
    Spacestuff::Ai::Behaviour::FireAtTarget.priority(actor).should == 0
  end
end
