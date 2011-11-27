When /^I run the simulation$/ do
  10.times do
    @minds.each { |ai| ai.update(100) }
    @location.update(100)
  end
end
