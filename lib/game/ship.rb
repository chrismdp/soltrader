module Spacestuff
  module Game
    class Ship
      attr :pieces, :x, :y, :velocity_x, :velocity_y, :angle

      def initialize(options = {})
        @next_fire = 0
        @orders = []
        @seconds_elapsed = 0
        @x = options[:x]
        @y = options[:y]
        @location = options[:location]
        @ai = options[:ai]
        @pieces = []
        @velocity_x = 0
        @velocity_y = 0
        @angle = 0

        options[:schematic].build(self) if options[:schematic]
        @location.place(self)
      end

      def rate_of_acceleration
        400 * @seconds_elapsed
      end

      def rate_of_braking
        120 * @seconds_elapsed
      end

      def turn_left
        @angle -= 300 * @seconds_elapsed
        notify(:turned)
      end

      def update(elapsed)
        @seconds_elapsed = elapsed
        process_received_input

        @next_fire -= @seconds_elapsed

        @x += @velocity_x * @seconds_elapsed
        @y += @velocity_y * @seconds_elapsed

        apply_damping_effect
      end

      def order(order)
        @orders << order
      end

      def process_received_input
        @orders.each {|order| self.send(order) }
        @orders = []
      end

      def apply_damping_effect
        @velocity_x *= 1 - (0.3 * @seconds_elapsed)
        @velocity_y *= 1 - (0.3 * @seconds_elapsed)
      end

      def scan
        distances = []
        @location.each_entity do |entity|
          next if entity == self
          distances.push({:square_distance => (@x - entity.x) ** 2 + (@y - entity.y) ** 2, :entity => entity})
        end
        return nil if distances == []
        distances.min_by {|x| x[:square_distance]}[:entity]
      end

      def turn_right
        @angle += 5
        notify(:turned)
      end

      def fire
        if (@next_fire <= 0)
          @next_fire = 0.3
          notify(:fired)
        end
      end

      def bolt_on(piece)
        @pieces << piece
      end

      def offset_y(angle, rate)
        -Math.cos(angle * Math::PI / 180.0) * rate
      end

      def offset_x(angle, rate)
        Math.sin(angle * Math::PI / 180.0) * rate
      end

      def fire_main_engines
        @velocity_x += offset_x(@angle, rate_of_acceleration)
        @velocity_y += offset_y(@angle, rate_of_acceleration)
        notify(:engine_fired)
      end

      def fire_reverse_engines
        @velocity_x -= offset_x(@angle, rate_of_braking)
        @velocity_y -= offset_y(@angle, rate_of_braking)
        notify(:engine_fired)
      end

      def size
        x, y = [], []
        pieces.map do |piece|
          x << piece.x + piece.width
          y << piece.y + piece.height
        end
        [x.max, y.max]
      end

      # listening
      def listen(listener, event)
        @listeners ||= Hash.new([])
        @listeners[event].push(listener)
      end

      def notify(event)
        if @listeners && listeners_for_event = @listeners[event]
          listeners_for_event.each { |listener| listener.send(event) }
        end
      end
    end
  end
end
