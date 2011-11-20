Given /^(\d+) ships with basic tracking AI$/ do |ship_count|
  ship_count = ship_count.to_i
  schematic = Spacestuff::Game::Schematic.new
  schematic.draw(Spacestuff::Game::HullPiece.new(:x => 0, :y => 0, :width => 48, :height => 48))
  schematic.draw(Spacestuff::Game::CockpitPiece.new(:x => 3, :y => 2, :width => 5, :height => 5))
  schematic.draw(Spacestuff::Game::EnginePiece.new(:x => 2, :y => 4, :width => 5, :height => 5))
  schematic.draw(Spacestuff::Game::EnginePiece.new(:x => 4, :y => 4, :width => 5, :height => 5))
  @ships ||= []
  @minds ||= []
  ship_count.times do |count|
    ship = Spacestuff::Game::Ship.new(:schematic => schematic, :x => 1000 + (count * 200), :y => 1000 + (count * 200), :location => @location)
    actor = Spacestuff::Ai::Actor.new :behaviours => [
      Spacestuff::Ai::Behaviour::Awol
    ]
    actor.take_controls_of(ship)
    @ships << ship
    @minds << actor
  end
end

Then /^the ships should track each other$/ do
  @ships.first.angle.should be_between(0, Math::PI)
  @ships.last.angle.should be_between(Math::PI, 2 * Math::PI)
end
