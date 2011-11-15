require 'spec_helper'

require 'ai/behaviour/awol'

describe Spacestuff::Ai::Behaviour::Awol do
  let(:actor) { double }
  it "Will go awol if the actor is tagged 'nutter'" do
    actor.stub(:tagged?).with(:nutter).and_return(false)
    Spacestuff::Ai::Behaviour::Awol.priority(actor).should == 0
    actor.stub(:tagged?).with(:nutter).and_return(true)
    Spacestuff::Ai::Behaviour::Awol.priority(actor).should == 100
  end


end
