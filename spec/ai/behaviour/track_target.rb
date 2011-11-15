require 'spec_helper'

require 'ai/behaviour/track_target'

describe Spacestuff::Ai::Behaviour::TrackTarget do
  let(:actor) { double }
  let(:parent) { double }
  it "has no priority if there's no target" do
    Spacestuff::Ai::Behaviour::Idle.priority(actor, parent).should == 1
  end
end
