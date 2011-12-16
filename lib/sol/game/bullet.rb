module Sol
  module Game
    class Bullet
      include Sol::Game::Physical

      def initialize(options = {})
        self.make_circle(10, 10)
        @shape.collision_type = :bullet
        @shape.group = :bullet
        @shape.layers = Physical::LAYER_SHIP

        @body.p = options[:position]
        @body.a = options[:angle]
        @body.v = options[:velocity]
        @body.w = 15
        @body.apply_impulse(@body.a.radians_to_vec2 * 5000, CP::Vec2::ZERO)
        @lifespan = Sol::Game::Lifespan.new(700)
        super
      end

      def update(elapsed)
        @lifespan.update(elapsed)
        @lifespan.finished?
      end

      def percentage_lifetime
        @lifespan.percentage_lifetime
      end
    end

  end
end
