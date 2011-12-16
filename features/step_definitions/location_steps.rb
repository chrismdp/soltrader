Given /^a simple game location$/ do
  @location = Sol::Game::Location.new(:name => "Earth Orbit", :width => 10000, :height => 10000)
end

Given /^a planet ready to trade$/ do
  Sol::Game::CelestialBody.new(:position => vec2(5000, 5000), :location => @location, :image => 'earth.png', :name => 'Earth')
end

Given /^another location connected via a jump gate$/ do
  @second_location = Sol::Game::Location.new(:name => "Mars Orbit", :width => 10000, :height => 10000)
  earth_gate = Sol::Game::JumpGate.new(:position => vec2(5000, 4500), :location => @location)
  mars_gate = Sol::Game::JumpGate.new(:position => vec2(5000, 4500), :location => @second_location)
  earth_gate.connect_to(mars_gate)
end
