module Sol
  module Game
    class Location
      attr :name, :width, :height

      def initialize(options = {})
        @name = options[:name]
        @width = options[:width]
        @height = options[:height]
        @placements = {}
        @remove_list = []
        @add_list = []
        setup_space
      end

      def setup_space
        @space = CP::Space.new
        @space.damping = 0.75
 
        @space.add_collision_func(:ship, :bullet) do |ship_shape, bullet_shape|
          remove_later(@placements[bullet_shape.body])
          if (ship = @placements[ship_shape.body])
            ship.hit!
            if (ship.dead?)
              remove_later(ship)
              false
            end
          end
          true
        end

        @space.add_collision_func(:ship, :gate) do |ship_shape, gate_shape|
          ship = @placements[ship_shape.body]
          if (ship.location == self) # might have already moved this frame
            @placements[gate_shape.body].move_from(ship)
          end
          false
        end
      end

      def place(entity)
        @placements[entity.body] = entity
        @space.add_body(entity.body)
        @space.add_shape(entity.shape)
      end

      def remove(entity)
        return if entity.nil?
        @placements.delete(entity.body)
        @space.remove_body(entity.body)
        @space.remove_shape(entity.shape)
      end

      def remove_later(entity)
        @remove_list << entity
      end

      def add_later(entity)
        @add_list << entity
      end

      def do_changes
        @remove_list.each {|e| remove(e) }
        @remove_list = []
        @add_list.each {|e| place(e) }
        @add_list = []
      end

      def each_entity
        @placements.values.each do |placement|
          yield placement
        end
      end

      def each_entity_with_box(left, top, right, bottom)
        bb = CP::BB.new(left, top, right, bottom)
        @space.bb_query(bb) do |shape|
          yield @placements[shape.body]
        end
      end

      def entity_count
        @placements.size
      end

      def update(elapsed)
        each_entity do |entity|
          remove = entity.update(elapsed)
          remove(entity) if remove
        end
        update_physics(elapsed)
      end

      def update_physics(dt)
        @space.step(dt/1000.0)
        do_changes
      end

      def nearest_to(target)
        distances = []
        each_entity_with_box(target.x - 400, target.y - 400, target.x + 400, target.y + 400) do |entity|
          next if entity == target || !entity.is_a?(Sol::Game::Ship)
          distances.push({:square_distance => (target.x - entity.x) ** 2 + (target.y - entity.y) ** 2, :entity => entity})
        end
        return nil if distances == []
        distances.min_by {|x| x[:square_distance]}[:entity]
      end

      def exit_to(location)
        each_entity do |entity|
          if (entity.respond_to?(:connected_gate) &&
            entity.connected_gate &&
            entity.connected_gate.location == location)
            return entity
          end
        end
        return nil
      end
    end
  end
end
