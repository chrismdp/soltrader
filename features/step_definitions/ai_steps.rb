When /^I run the AI$/ do
  @minds.each { |ai| ai.update(1000) }
end
