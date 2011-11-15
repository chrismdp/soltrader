Given /^a simple game location$/ do
  @location = Spacestuff::Game::Location.new(:name => "Earth Orbit", :width => 10000, :height => 10000)
end
