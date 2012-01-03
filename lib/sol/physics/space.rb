module Sol
  module Physics
    class Space
      def initialize(options)
        @location = options[:location]
        @space = CP::Space.new
        @space.damping = 0.75
        @space.add_collision_func(:ship, :bullet) do |ship_shape, bullet_shape|
          @location.remove_later(@location.from_shape(bullet_shape))
          if (ship = @location.from_shape(ship_shape))
            ship.hit!
            if (ship.dead?)
              @location.remove_later(ship)
              false
            end
          end
          true
        end

        @space.add_collision_func(:ship, :gate) do |ship_shape, gate_shape|
          ship = @location.from_shape(ship_shape)
          if (ship.location == @location) # might have already moved this frame
            @location.from_shape(gate_shape).move_from(ship)
          end
          false
        end

        @space.add_collision_func(:ship, :celestial_body) do |ship_shape, celestial_body_shape|
          ship = @location.from_shape(ship_shape)
          if (ship.attempting_interact?) # might have already moved this frame
            ship.interact_acknowledged!
            @location.from_shape(celestial_body_shape).move_from(ship)
          end
          false
        end
      end

      def add(shape)
        @space.add_body(shape.body)
        @space.add_shape(shape)
      end


      def remove(shape)
        @space.remove_body(shape.body)
        @space.remove_shape(shape)
      end

      def update(elapsed)
        @space.step(elapsed/1000.0)
      end

      def all_within(bb, &block)
        @space.bb_query(bb, &block)
      end
    end
  end
end
