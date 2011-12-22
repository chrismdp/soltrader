require 'spec_helper'

require 'chipmunk'
require 'game/location'
require 'game/space'
require 'game/physical'
require 'game/gate'
require 'game/jump_gate'
require 'game/celestial_body'
require 'persistence/map_loader'

describe Sol::Persistence::MapLoader do
  subject { Sol::Persistence::MapLoader.new("spec/fixtures/map_simple.yml") }

  it "creates locations" do
    subject.locations.size.should == 2
    location = subject.locations[:earth_orbit]
    location.should be_a(Sol::Game::Location)
    location.name.should == "Earth Orbit"
    location.width.should == 10000
    location.height.should == 10000
  end

  def from(name, type)
    target = nil
    subject.locations[name].each_entity do |entity|
      target = entity if entity.is_a?(type)
    end
    target
  end

  context "jump gates" do
    let(:gate) { from(:earth_orbit, Sol::Game::JumpGate) }

    it "creates with position" do
      gate.position.should == vec2(5000, 4500)
    end

    it "creates a connection" do
      gate.connected_gate.location.should == subject.locations[:mars_orbit]
    end
  end

  context "bodies" do
    let(:body) { from(:earth_orbit, Sol::Game::CelestialBody) }

    it "creates with details" do
      body.position.should == vec2(5000, 5000)
      body.image.should == "earth.png"
      body.name.should == "Earth"
    end
  end
end
