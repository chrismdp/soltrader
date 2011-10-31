require_relative "spec_helper"

require 'chingu'
require 'texplay'
include Gosu

require_relative "../lib/spacestuff"

RSpec.configure do |config|
  config.before(:suite) do
    @window = Spacestuff::Game.new
  end
end

