module Spacestuff
  module Game
    class Bullet
      include Spacestuff::Game::Physical

      def initialize(options = {})
        self.make_circle(10, 10)
        @shape.collision_type = :bullet
        @shape.group = :bullet
        @shape.layers = Physical::LAYER_SHIP

        @body.p = options[:position]
        @body.a = options[:angle]
        @body.v = options[:velocity]
        @body.apply_impulse(@body.a.radians_to_vec2 * 5000, CP::Vec2::ZERO)
        @lifespan = Spacestuff::Game::Lifespan.new(500)
      end

      def update(elapsed)
        @lifespan.update(elapsed)
        @lifespan.finished?
      end

      def percentage_lifetime
        @lifespan.percentage_lifetime
      end
    end

    class Exhaust
      include Spacestuff::Game::Physical
      attr :lifetime

      def initialize(options = {})
        self.make_circle(1, 10)
        @shape.group = :bullet
        @shape.layers = Physical::LAYER_EXHAUST

        @body.p = options[:position]
        @body.a = rand(2 * Math::PI)
        @body.w = 20
        @lifespan = Spacestuff::Game::Lifespan.new(500)
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
