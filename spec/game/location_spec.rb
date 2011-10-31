require 'spec_helper'
require 'game/location'

describe Spacestuff::Game::Location do
  it "has a world position" do
    loc = Spacestuff::Game::Location.new(1,1)
    loc.x.should == 1
    loc.y.should == 1
  end

end
