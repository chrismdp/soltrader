When /^an actor is created$/ do
  @actor = Spacestuff::Ai::Actor.new :behaviours => [
    Spacestuff::Ai::Behaviour::Awol,
    Spacestuff::Ai::Behaviour::Idle
  ]
end

Then /^he picks from a number of high\-level options$/ do
  pending "Need more high-level behaviours to make this scenario worthwhile"
  @actor.update(1)
  @actor.current_behaviour.should_not be_nil
end
