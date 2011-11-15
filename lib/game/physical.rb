module Spacestuff
  module Game
    module Physical
      LAYER_SHIP = 1
      LAYER_EXHAUST = 2
      LAYER_CELESTIAL_BODY = 4

      def self.included(klass)
        klass.extend(self)
      end

      def self.extended(thing)
        class_eval do
          attr :shape, :body
          def make_circle(mass, radius)
            @body = CP::Body.new(mass, CP.moment_for_circle(mass, 0.0, radius, CP::Vec2::ZERO))
            @shape = CP::Shape::Circle.new(@body, mass, CP::Vec2::ZERO)
          end
        end
      end

      def x
        @body.p.x
      end
      def y
        @body.p.y
      end
      def angle
        @body.a
      end
    end
  end
end