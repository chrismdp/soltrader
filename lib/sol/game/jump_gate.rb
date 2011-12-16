module Sol
  module Game
    class JumpGate
      include Sol::Game::Physical
      include Sol::Game::Gate

      attr :connected_gate

      def initialize(options = {})
        @body = CP::Body.new(10000, 128)
        shape_array = [CP::Vec2.new(-80.0, -16.0), CP::Vec2.new(-80.0, 16.0), CP::Vec2.new(80.0, 16.0), CP::Vec2.new(80.0, -16.0)]
        @shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))

        @shape.layers = Physical::LAYER_SHIP
        @shape.collision_type = :gate
        @shape.group = :bullet
        @body.p = options[:position]
        super
      end

      def update(elapsed)
        @elapsed = elapsed
        return super
      end

      def after_move_from(ship, destination_time)
        raise "Cannot move without connection!" unless @connected_gate
        ship.jump_into_gate(self, destination_time)
      end

      def after_move_to(ship)
        ship.drop_in(@connected_gate.location, @connected_gate.position)
      end

      def connect_to(other)
        raise ArgumentError unless @connected_gate.nil?
        raise ArgumentError if self == other
        raise ArgumentError if self.location == other.location
        @connected_gate = other
        other.connect_to(self) if other.connected_gate.nil?
      end

      def destination
        connected_gate.location.name
      end

      def add_spooky_purple_smoke
        throttle(:purple_smoke, 200, @elapsed) do
          Sol::Game::Mist.new(:location => @location, :position => position, :velocity => vec2(rand(100) - 50, rand(300) - 150), :lifetime => 10000)
        end
      end
    end
  end
end
