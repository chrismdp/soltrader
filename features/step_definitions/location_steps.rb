Given /^a simple game location$/ do
  @location = Spacestuff::Game::Location.new(:name => "Earth Orbit", :width => 10000, :height => 10000)
end

Given /^another location connected via a jump gate$/ do
  @second_location = Spacestuff::Game::Location.new(:name => "Mars Orbit", :width => 10000, :height => 10000)
  earth_gate = Spacestuff::Game::JumpGate.new(:position => vec2(5000, 4500), :location => @location)
  mars_gate = Spacestuff::Game::JumpGate.new(:position => vec2(5000, 4500), :location => @second_location)
  earth_gate.connect_to(mars_gate)
end
