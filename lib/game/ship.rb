module Spacestuff
  module Game
    class Ship
      attr :pieces, :shape, :body, :lives
      include Spacestuff::Listenable

      def initialize(options = {})
        @next_fire = 0
        @orders = []
        @seconds_elapsed = 0
        @location = options[:location]
        @ai = options[:ai]

        initialize_physics(options)

        @pieces = []

        options[:schematic].build(self) if options[:schematic]
        @location.place(self)
        @lives = 5
        @hit_this_frame
      end

      def hit!
        @lives -= 1 unless @hit_this_frame
        @hit_this_frame = true
      end

      def dead?
        @lives <= 0
      end

      def initialize_physics(options)
        @body = CP::Body.new(10.0, 150.0)
        shape_array = [CP::Vec2.new(-25.0, -25.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 1.0), CP::Vec2.new(25.0, -1.0)]
        @shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
        @shape.collision_type = :ship

        @shape.body.p = CP::Vec2.new(options[:x], options[:y])
        @shape.body.v = CP::Vec2.new(0.0, 0.0)
      end


      def rate_of_acceleration
        100
      end

      def rate_of_braking
        50
      end

      TURN_RATE = 0.8
      ROTATIONAL_DAMPING = 0.85

      def turn_left
        @shape.body.w -= TURN_RATE
        notify(:turned)
      end

      def turn_right
        @shape.body.w += TURN_RATE
        notify(:turned)
      end


      def update(elapsed)
        @seconds_elapsed = elapsed
        @shape.body.w *= ROTATIONAL_DAMPING
        process_received_input

        @next_fire -= @seconds_elapsed
        @hit_this_frame = false
      end

      def order(order)
        @orders << order
      end

      def process_received_input
        @orders.each {|order| self.send(order) }
        @orders = []
      end

      def scan
        # TODO: Could be replaced by a largish collision detection in the physics?
        distances = []
        @location.each_entity do |entity|
          next if entity == self
          distances.push({:square_distance => (self.x - entity.x) ** 2 + (self.y - entity.y) ** 2, :entity => entity})
        end
        return nil if distances == []
        distances.min_by {|x| x[:square_distance]}[:entity]
      end

      def x
        @shape.body.p.x
      end

      def y
        @shape.body.p.y
      end

      def angle
        @shape.body.a
      end

      def fire
        if (@next_fire <= 0)
          @next_fire = 0.3
          notify(:fired)
          offset = self.angle.radians_to_vec2
          position = self.body.p + offset * 40
          @location.place(Spacestuff::Game::Bullet.new(:position => position, :velocity => self.body.v, :angle => self.angle))
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
        @shape.body.apply_impulse((@shape.body.a.radians_to_vec2 * rate_of_acceleration), CP::Vec2.new(0.0, 0.0))
        notify(:engine_fired)
      end

      def fire_reverse_engines
        @shape.body.apply_impulse(-(@shape.body.a.radians_to_vec2 * rate_of_acceleration), CP::Vec2.new(0.0, 0.0))
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
    end
  end
end
