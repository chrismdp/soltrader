require 'spec_helper'

require 'game/gate'
require 'game/physical'
require 'chipmunk'
require 'game/celestial_body'

describe Sol::Game::CelestialBody do
  let(:location) { double.as_null_object }
  let(:ship) { double.as_null_object }

  let(:subject) { Sol::Game::CelestialBody.new(:position => vec2(1,1), :location => location) }
  it "can be created" do
    subject
  end

  context "moving" do
    it "starts a re-entry effect" do
      ship.should_receive(:enter_atmosphere)
      subject.after_move_from(ship, 1)
    end
  end
end
