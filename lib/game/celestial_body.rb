module Sol
  module Game
    class CelestialBody
      attr :image, :name

      include Sol::Game::Physical
      include Sol::Game::Gate
      def initialize(options = {})
        make_circle(128, 256)

        @shape.layers = Physical::LAYER_SHIP
        @shape.collision_type = :celestial_body
        @shape.group = :bullet
        @body.p = options[:position]
        @image = options[:image]
        @name = options[:name]

        super
      end

      def after_move_from(ship, destination_time)
        ship.jump_into_gate(self, destination_time)
      end

      def after_move_to(ship)
        # TODO: Now on the planet
      end

      def destination
        name
      end
    end
  end
end
