require_relative "spec_helper"

require 'chingu'
require 'texplay'
require 'chipmunk'
include Gosu

require_relative "../lib/sol"

RSpec.configure do |config|
  config.before(:suite) do
    @window = Sol::Window.new
  end
end

