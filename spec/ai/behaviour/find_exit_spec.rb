require 'spec_helper'

require 'shared_examples/ai/behaviour'
require 'ai/behaviour/behaviour'
require 'ai/behaviour/find_exit'

describe Spacestuff::Ai::Behaviour::FindExit do
  let(:ship) { double }
  let(:actor) { double(:actor, :current_target => nil, :destination => nil, :ship => ship) }
  let(:destination) { double }

  subject { Spacestuff::Ai::Behaviour::FindExit.new(:actor => actor) }

  it_behaves_like "a behaviour"

  it "has a priority if there is a destination and no current target" do
    Spacestuff::Ai::Behaviour::FindExit.priority(actor).should == 0
    actor.should_receive(:destination).and_return(destination)
    actor.stub(:current_target => double)
    Spacestuff::Ai::Behaviour::FindExit.priority(actor).should == 0
    actor.stub(:current_target => nil)
    Spacestuff::Ai::Behaviour::FindExit.priority(actor).should_not == 0
  end

  describe "update" do
    it "finds an exit for the location we are travelling to" do
      actor.stub(:destination => destination)

      actor.should_receive(:acquire_target).with(:exit_to => destination)
      subject.update(100)
    end

    it "returns done when we've found one" do
      actor.stub(:acquire_target => double)
      actor.stub(:current_target => double)
      subject.update(100).should == Spacestuff::Ai::Behaviour::DONE
    end
  end
end
