module Spacestuff
  module Game
    class Ship
      attr :pieces, :x, :y, :velocity_x, :velocity_y, :angle

      def initialize(options = {})
        @x = options[:x]
        @y = options[:y]
        @location = options[:location]
        @pieces = []
        @velocity_x = 0
        @velocity_y = 0
        @angle = 0

        options[:schematic].build(self) if options[:schematic]
        @location.place(self)
      end

      def rate_of_acceleration
        0.2
      end

      def rate_of_braking
        0.05
      end

      def turn_left
        @angle -= 5
        notify(:turned)
      end

      def update
        @x += @velocity_x
        @y += @velocity_y
      end

      def turn_right
        @angle += 5
        notify(:turned)
      end

      def fire
        notify(:fired)
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
