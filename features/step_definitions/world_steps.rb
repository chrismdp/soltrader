Given /^a system at a starting state$/ do
  earth = Spacestuff::Universe::Planet.new
  mars = Spacestuff::Universe::Planet.new
  Spacestuff::Universe::JumpGate.new(:from => earth, :to => mars, :duration_in_minutes => 120)
end
