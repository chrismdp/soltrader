module Spacestuff
  module Game
    class Bullet
      attr :shape, :body

      MASS = 10.0
      RADIUS = 10.0
      FORCE = 30
      def initialize(options = {})
        @body = CP::Body.new(MASS, CP.moment_for_circle(MASS, 0.0, RADIUS, CP::Vec2::ZERO))
        @shape = CP::Shape::Circle.new(@body, RADIUS, CP::Vec2::ZERO)
        @shape.collision_type = :bullet

        @body.p = options[:position]

        @body.apply_force((options[:angle].radians_to_vec2 * FORCE), CP::Vec2.new(0.0, 0.0))
      end

      def update(elapsed)
      end

      def x
        @shape.body.p.x
      end

      def y
        @shape.body.p.y
      end
    end
  end
end
