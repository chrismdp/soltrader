def schematic
  unless @schematic
    @schematic = Spacestuff::Game::Schematic.new
    @schematic.draw(Spacestuff::Game::HullPiece.new(:x => 0, :y => 0, :width => 48, :height => 48))
    @schematic.draw(Spacestuff::Game::CockpitPiece.new(:x => 3, :y => 2, :width => 5, :height => 5))
    @schematic.draw(Spacestuff::Game::EnginePiece.new(:x => 2, :y => 4, :width => 5, :height => 5))
    @schematic.draw(Spacestuff::Game::EnginePiece.new(:x => 4, :y => 4, :width => 5, :height => 5))
  end
  return @schematic
end

def ship(count = 1, behaviour = [ Spacestuff::Ai::Behaviour::Awol])
  @ships ||= []
  @minds ||= []
  count.times do |count|
    ship = Spacestuff::Game::Ship.new(:schematic => schematic, :x => 1000 + (count * 200), :y => 1000 + (count * 200), :location => @location)
    actor = Spacestuff::Ai::Actor.new :behaviours => behaviour
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
  ship(1, [Spacestuff::Ai::Behaviour::Travel])
  @minds.last.destination = @second_location
end

Then /^the ship should pathfind to the second location$/ do
  @ships.last.position.should_not == vec2(1000,1000)
end
