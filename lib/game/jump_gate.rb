module Sol
  module Game
    class JumpGate
      attr :location, :connected_gate

      include Sol::Game::Physical
      def initialize(options = {})
        @body = CP::Body.new(10000, 128)
        shape_array = [CP::Vec2.new(-80.0, -16.0), CP::Vec2.new(-80.0, 16.0), CP::Vec2.new(80.0, 16.0), CP::Vec2.new(80.0, -16.0)]
        @shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
        @location = options[:location]
        @location.place(self)
        @shape.layers = Physical::LAYER_SHIP
        @shape.collision_type = :gate
        @shape.group = :bullet
        @body.p = options[:position]
      end

      def update(elapsed)
        @elapsed = elapsed
        return false
      end

      def connect_to(other)
        raise ArgumentError unless @connected_gate.nil?
        raise ArgumentError if self == other
        raise ArgumentError if self.location == other.location
        @connected_gate = other
        other.connect_to(self) if other.connected_gate.nil?
      end

      def move_from(ship)
        raise "Cannot move without connection!" unless @connected_gate
        ship.location.remove_later(ship)
        @connected_gate.move_to(ship)
      end

      def move_to(ship)
        ship.drop_in(@location, position)
      end

      def add_spooky_purple_smoke
        throttle(:purple_smoke, 200, @elapsed) do

          @location.place(Sol::Game::Mist.new(:position => position, :velocity => vec2(rand(100) - 50, rand(300) - 150), :lifetime => 10000))
        end
      end
    end
  end
end
