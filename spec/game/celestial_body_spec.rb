require 'spec_helper'

require 'game/gate'
require 'game/physical'
require 'chipmunk'
require 'game/celestial_body'

describe Sol::Game::CelestialBody do
  let(:location) { double.as_null_object }
  it "can be created" do
    Sol::Game::CelestialBody.new(:position => vec2(1,1), :location => location)
  end
end
