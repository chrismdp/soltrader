require_relative "game/ship"
require_relative "game/pieces"
require_relative "game/schematic"
require_relative "game/location"
require_relative "game/ship_ai"

module Spacestuff
  class Window < Chingu::Window
    def initialize
      super
      Gosu::Image.autoload_dirs << File.join(File.dirname(__FILE__), "..", "media")
      self.input = { :escape => :exit }
      self.push_game_state(Spacestuff::Gamestates::Space)
    end

    def update
      super
    end
  end
end

class Numeric
  def radians_to_vec2
    CP::Vec2.new(Math::cos(self), Math::sin(self))
  end
end
