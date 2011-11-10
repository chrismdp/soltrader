module Spacestuff
  module Game
    class Bullet
      include Spacestuff::Game::Physical

      MASS = 10.0
      RADIUS = 10.0
      def initialize(options = {})
        @body = CP::Body.new(MASS, CP.moment_for_circle(MASS, 0.0, RADIUS, CP::Vec2::ZERO))
        @shape = CP::Shape::Circle.new(@body, RADIUS, CP::Vec2::ZERO)
        @shape.collision_type = :bullet
        @shape.group = :bullet
        @shape.layers = 1

        @body.p = options[:position]
        @body.a = options[:angle]
        @body.v = options[:velocity]
        @body.apply_impulse(@body.a.radians_to_vec2 * 5000, CP::Vec2::ZERO)
        @lifespan = Spacestuff::Game::Lifespan.new(0.5)
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

      MASS = 1
      RADIUS = 10
      def initialize(options = {})
        @body = CP::Body.new(MASS, CP.moment_for_circle(MASS, 0.0, RADIUS, CP::Vec2::ZERO))
        @shape = CP::Shape::Circle.new(@body, RADIUS, CP::Vec2::ZERO)
        @shape.collision_type = :never
        @shape.group = :bullet
        @shape.layers = 2

        @body.p = options[:position]
        @body.a = rand(2 * Math::PI)
        @body.w = 20
        @lifespan = Spacestuff::Game::Lifespan.new(0.5)
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
