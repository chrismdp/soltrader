module Sol
  module Game
    class CelestialBody
      attr :image

      include Sol::Game::Physical
      def initialize(options = {})
        make_circle(1, 256)

        @shape.collision_type = :celestial_body
        @shape.group = :bullet
        @shape.layers = Physical::LAYER_CELESTIAL_BODY

        @body.p = options[:position]
        @image = options[:image]

        super
      end

      def update(elapsed)

      end
    end
  end
end
