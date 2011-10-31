require_relative "spec_helper"

require 'chingu'
require 'texplay'
include Gosu

require_relative "../lib/spacestuff"

RSpec.configure do |config|
  config.before(:each) do
    @window = Spacestuff::Game.new
  end

  config.after(:each) do
    @window.close
  end
end

