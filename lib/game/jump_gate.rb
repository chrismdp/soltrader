module Sol
  module Game
    class JumpGate
      attr :location, :connected_gate, :jumping

      include Sol::Game::Physical
      include Sol::Game::Gate

      def initialize(options = {})
        @body = CP::Body.new(10000, 128)
        shape_array = [CP::Vec2.new(-80.0, -16.0), CP::Vec2.new(-80.0, 16.0), CP::Vec2.new(80.0, 16.0), CP::Vec2.new(80.0, -16.0)]
        @shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))

        @shape.layers = Physical::LAYER_SHIP
        @shape.collision_type = :gate
        @shape.group = :bullet
        @body.p = options[:position]

        @jump_seconds = options[:jump_seconds] || 5
        super
      end

      def update(elapsed)
        @elapsed = elapsed
        return super
      end

      def move_from(ship)
        super do |destination_time|
          ship.jump_into_gate(self, destination_time)
        end
      end

      def move_to(ship)
        ship.drop_in(@location, position)
      end

      def add_spooky_purple_smoke
        throttle(:purple_smoke, 200, @elapsed) do
          Sol::Game::Mist.new(:location => @location, :position => position, :velocity => vec2(rand(100) - 50, rand(300) - 150), :lifetime => 10000)
        end
      end
    end
  end
end
