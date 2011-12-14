When /^I load a world map$/ do
  @locations = Sol::Persistence::MapLoader.new("spec/fixtures/map_simple.yml").locations
end

Then /^the map should be loaded correctly$/ do
  @locations.count.should == 2
end

Given /^a system at a starting state$/ do
end
