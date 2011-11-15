require 'spec_helper'

require 'shared_examples/ai/behaviour'
require 'ai/behaviour'
require 'ai/behaviour/track_target'

describe Spacestuff::Ai::Behaviour::TrackTarget do
  let(:actor) { double }
  subject { Spacestuff::Ai::Behaviour::TrackTarget.new(:actor => actor) }

  it_behaves_like "a behaviour"

  it "has no priority if there's no target" do
    Spacestuff::Ai::Behaviour::TrackTarget.priority(actor).should == 0
  end

  it "has a priority if there is a target"
end
