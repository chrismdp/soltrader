require 'spec_helper'

shared_examples_for "it runs children by priority" do
  let(:behaviour) { double.as_null_object }
  let(:behaviours) { (1..10).collect{|x| double(:behaviour_class, :priority => x).as_null_object } }
  before do
    subject.behaviours = behaviours
    behaviours.last.stub(:new => behaviour)
  end

  it "calls priority on the behaviours, passing the actor" do
    behaviours.each { |b| b.should_receive(:priority).with(actor) }
    subject.update(1)
  end

  it "instantiates the highest priority behaviour" do
    behaviours.last.should_receive(:new).and_return(behaviour)
    subject.update(1)
    subject.current_behaviour.should == behaviour
  end

end
