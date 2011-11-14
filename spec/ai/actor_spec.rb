require 'spec_helper'
require 'ai/actor'

describe Spacestuff::Ai::Actor do
  let(:behaviours) { (1..10).collect{|x| double(:behaviour, :priority => x) } }
  subject { Spacestuff::Ai::Actor.new(:behaviours => behaviours) }

  it "allows update with an elapsed duration" do
    subject.update(1)
  end

  it "picks the highest prioritised behaviour from his options" do
    subject.update(1)
    subject.current_behaviour.priority(subject).should == 10
  end
end
