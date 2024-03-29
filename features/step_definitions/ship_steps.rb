def schematic
  unless @schematic
    @schematic = Sol::Game::Schematic.new
    @schematic.draw(Sol::Game::HullPiece.new(:x => 0, :y => 0, :width => 48, :height => 48))
    @schematic.draw(Sol::Game::CockpitPiece.new(:x => 3, :y => 2, :width => 5, :height => 5))
    @schematic.draw(Sol::Game::EnginePiece.new(:x => 2, :y => 4, :width => 5, :height => 5))
    @schematic.draw(Sol::Game::EnginePiece.new(:x => 4, :y => 4, :width => 5, :height => 5))
  end
  return @schematic
end

def ship(count = 1, behaviour = [:awol])
  @ships ||= []
  @minds ||= []
  count.times do |count|
    ship = Sol::Game::Ship.new(:schematic => schematic, :x => 1000 + (count * 200), :y => 1000 + (count * 200), :location => @location)
    actor = Sol::Ai::Actor.new :behaviours => behaviour
    actor.take_controls_of(ship)
    @ships << ship
    @minds << actor
  end
  @ships.last
end

Given /^(\d+) ships with basic tracking AI$/ do |ship_count|
  ship_count = ship_count.to_i
  ship(ship_count)
end

Then /^the ships should track each other$/ do
  @ships.first.angle.should be_between(0, Math::PI)
  @ships.last.angle.should be_between(-Math::PI, 0)
end

Given /^a ship ordered to travel between the two locations$/ do
  ship(1, [:travel])
  @minds.last.destination = @second_location
end

Then /^the ship should travel to the second location$/ do
  @ships.last.position.should_not == vec2(1000,1000)
end
