require 'spec_helper'

require 'game/celestial_body'

describe Spacestuff::Game::CelestialBody do
  let(:location) { double.as_null_object }
  it "can be created" do
    Spacestuff::Game::CelestialBody.new(:position => vec2(1,1), :location => location)
  end
end
