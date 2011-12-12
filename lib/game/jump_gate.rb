module Sol
  module Game
    class JumpGate
      attr :location, :connected_gate, :jumping

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
        @jump_seconds = options[:jump_seconds] || 5
        @jumping = []
        @total_seconds_elapsed = 0
      end

      def update(elapsed)
        @elapsed = elapsed
        @total_seconds_elapsed += elapsed / 1000.0

        @jumping.each do |arrival_time, jumper|
          if arrival_time < @total_seconds_elapsed
            @connected_gate.move_to(jumper)
            @jumping.shift
          else
            break
          end
        end

        # FIXME: Not happy about this boolean primitive here: should return REMOVE or similar
        return false
      end

      def time_to(time)
        time - @total_seconds_elapsed
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
        destination_time = @total_seconds_elapsed + @jump_seconds
        ship.jump_into_gate(self, destination_time)
        @jumping << [destination_time, ship]
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
