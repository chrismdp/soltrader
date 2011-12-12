module Sol
  module Game
    class Ship
      attr :pieces, :lives, :location, :fired_engines_this_frame
      attr_accessor :debug_message

      include Sol::Game::Physical

      def initialize(options = {})
        @next_fire = 0
        @orders = []
        @elapsed = 0

        initialize_physics(options)

        @pieces = []
        options[:schematic].build(self) if options[:schematic]

        @location = options[:location]
        @location.place(self)

        @lives = 5
        @hit_this_frame = false
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

        # TODO: Should be defined by the pieces
        shape_array = [CP::Vec2.new(-25.0, -25.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 1.0), CP::Vec2.new(25.0, -1.0)]
        @shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))

        @shape.collision_type = :ship
        @shape.layers = Physical::LAYER_SHIP

        @shape.body.p = CP::Vec2.new(options[:x], options[:y])
        @shape.body.v = CP::Vec2::ZERO
      end

      def rate_of_acceleration
        50
      end

      def rate_of_braking
        5
      end

      TURN_RATE = 0.8
      ROTATIONAL_DAMPING = 0.85

      def turn_left
        @shape.body.w -= TURN_RATE
      end

      def turn_right
        @shape.body.w += TURN_RATE
      end


      def update(elapsed)
        @fired_engines_this_frame = false
        @elapsed = elapsed
        @shape.body.w *= ROTATIONAL_DAMPING
        process_received_input

        @next_fire -= @elapsed
        @hit_this_frame = false
      end

      def order(order)
        @orders << order
      end

      def drop_in(location, position)
        @location = location
        @location.add_later(self)
        self.position = position + vec2(0, 200)
      end

      def process_received_input
        @orders.each {|order| self.send(order) }
        @orders = []
      end

      def scan(options)
        if (options.include?(:exit_to))
          return @location.exit_to(options[:exit_to])
        end
        @location.nearest_to(self)
      end

      def fire
        if (@next_fire <= 0)
          @next_fire = 300
          offset = self.angle.radians_to_vec2
          position = self.body.p + offset * 40
          @location.place(Sol::Game::Bullet.new(:position => position, :velocity => self.body.v, :angle => self.angle))
        end
      end

      def bolt_on(piece)
        @pieces << piece
      end

      def offset_y(angle, rate)
        -Math.cos(angle) * rate
      end

      def offset_x(angle, rate)
        Math.sin(angle) * rate
      end

      def fire_main_engines
        @shape.body.apply_impulse((@shape.body.a.radians_to_vec2 * rate_of_acceleration), CP::Vec2::ZERO)
        @fired_engines_this_frame = true
      end

      def place_smoke
        offset = self.angle.radians_to_vec2
        position = self.body.p - offset * 25
        @location.place(Sol::Game::Exhaust.new(:position => position, :velocity => self.body.v, :angle => self.angle))
      end

      def fire_reverse_engines
        @shape.body.apply_impulse(-(@shape.body.a.radians_to_vec2 * rate_of_acceleration), CP::Vec2::ZERO)
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
