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

        @body.p = options[:position]
        @body.a = options[:angle]
        @body.v = options[:velocity]
        @body.apply_impulse(@body.a.radians_to_vec2 * 5000, CP::Vec2::ZERO)
      end

      def update(elapsed)
      end
    end
  end
end
