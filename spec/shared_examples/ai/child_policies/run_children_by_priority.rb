require 'spec_helper'

shared_examples_for "it runs children by priority" do
  let(:behaviours) { (1..10).collect{|x| double(:behaviour, :priority => x) } }
  before do
    subject.instance_variable_set(:@behaviours, behaviours)
  end

  it "picks the highest prioritised behaviour from his options" do
    subject.update(1)
    subject.current_behaviour.priority(subject).should == 10
  end
end
