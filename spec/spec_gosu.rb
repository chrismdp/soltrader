require_relative "spec_helper"

require 'chingu'
include Gosu

require_relative "../lib/spacestuff"

RSpec.configure do |config|
  config.before(:each) do
    Spacestuff::Game.new
  end

  config.after(:each) do
    $window.close
  end
end

