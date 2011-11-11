module Spacestuff
  module Game
    class CelestialBody
      include Spacestuff::Game::Physical
      def initialize(options = {})
        make_circle(1, 256)
        @location = options[:location]
        @location.place(self)

        @shape.group = :bullet
        @shape.layers = Physical::LAYER_CELESTIAL_BODY

        @body.p = options[:position]
      end

      def update(elapsed)

      end
    end
  end
end
