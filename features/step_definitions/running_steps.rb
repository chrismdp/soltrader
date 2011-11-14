When /^I run the game for (\d+) frames$/ do |frame_count|
  Spacestuff::Window.new(:frame_count => frame_count.to_i).show
end

Then /^it should exit successfully$/ do
  # No operation: if the game had not finished it would have crashed
end
