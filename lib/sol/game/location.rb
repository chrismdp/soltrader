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
        @space = (options[:physics] || Space).new(:location => self)
      end

      def place(entity)
        @placements[entity.body] = entity
        @space.add(entity.shape)
      end

      def remove(entity)
        return if entity.nil?
        @placements.delete(entity.body)
        @space.remove(entity.shape)
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
        @space.all_within(bb) do |shape|
          yield from_shape(shape)
        end
      end

      def from_shape(shape)
        @placements[shape.body]
      end

      def entity_count
        @placements.size
      end

      def update(elapsed)
        each_entity do |entity|
          remove = entity.update(elapsed)
          remove(entity) if remove
        end
        @space.update(elapsed)
        do_changes
      end

      RANGE = 400
      def nearest_to(target)
        distances = []
        each_entity_with_box(target.x - RANGE, target.y - RANGE, target.x + RANGE, target.y + RANGE) do |entity|
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
