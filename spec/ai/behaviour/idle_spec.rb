require 'spec_helper'

require 'ai/behaviour/idle'

describe Spacestuff::Ai::Behaviour::Idle do
  let(:actor) { double }
  it "Will go idle as a last resort" do
    Spacestuff::Ai::Behaviour::Idle.priority(actor).should == 1
  end
end
