require 'spec_helper'

require 'game/lifespan'

describe Spacestuff::Game::Lifespan do
  subject { Spacestuff::Game::Lifespan.new(0.5) }

  it "should have a percentage_lifetime of zero on creation" do
    subject.percentage_lifetime.should == 0.0
  end

  it "over time this should increase" do
    subject.update(0.25)
    subject.percentage_lifetime.should == 0.5
  end

  it "until it's done" do
    subject.update(2)
    subject.percentage_lifetime.should > 1
    subject.should be_finished
  end


end
