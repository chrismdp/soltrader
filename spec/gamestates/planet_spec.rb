require 'spec_gosu'

describe Sol::Gamestates::Planet do
  context "initialize" do
  end

  def initialize
    super
  end

  def draw
    super
    @font ||= Font["BebasNeue.otf", 75]
    @font.draw("LANDED ON #{@player_ship.planet.name}", 200, 200, 2)
  end

end
