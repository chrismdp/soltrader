require 'spec_helper'

require 'shared_examples/ai/behaviour'
require 'ai/behaviour/behaviour'
require 'ai/behaviour/fire_at_target'

describe Spacestuff::Ai::Behaviour::FireAtTarget do
  let(:ship) { double(:ship) }
  let(:actor) { double(:actor, :ship => ship, :current_target => nil) }
  let(:target) { double }
  subject { Spacestuff::Ai::Behaviour::FireAtTarget.new(:actor => actor) }

  it_behaves_like "a behaviour"

  it "has no priority if there's no target" do
    Spacestuff::Ai::Behaviour::FireAtTarget.priority(actor).should == 0
  end
  it "has no priority if there's no ship" do
    actor.stub(:ship => nil)
    Spacestuff::Ai::Behaviour::FireAtTarget.priority(actor).should == 0
  end

  it "has a priority if there is a target and we're close to it and facing" do
    actor.stub(:current_target => target)
    ship.stub(:angle_to => 0.4)
    ship.stub(:squared_distance_to => 100 ** 2)
    Spacestuff::Ai::Behaviour::FireAtTarget.priority(actor).should > 0
  end
end
