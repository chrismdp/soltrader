require 'spec_helper'

require 'ai/behaviour/awol'

describe Spacestuff::Ai::Behaviour::Awol do
  let(:actor) { double }

  context "priority" do
    it "Will go awol if the actor is tagged 'nutter'" do
      actor.stub(:tagged?).with(:nutter).and_return(false)
      Spacestuff::Ai::Behaviour::Awol.priority(actor).should == 0
      actor.stub(:tagged?).with(:nutter).and_return(true)
      Spacestuff::Ai::Behaviour::Awol.priority(actor).should == 100
    end
  end

  context "update" do
    let(:behaviours) { (1..10).collect{|x| double(:behaviour, :priority => x) } }
    subject { Spacestuff::Ai::Behaviour::Awol.new(:actor => actor, :behaviours => behaviours) }
    it "picks the highest prioritised behaviour from his options" do
      subject.update(1)
      subject.current_behaviour.priority(subject).should == 10
    end
  end
end
