module Spacestuff
  module Game
    class Location
      include Spacestuff::Listenable
      attr :name, :width, :height

      def initialize(options = {})
        @name = options[:name]
        @width = options[:width]
        @height = options[:height]
        @placements = {}
        @remove_list = []
        @space = CP::Space.new
        @space.add_collision_func(:ship, :bullet) do |ship, bullet|
          remove_later(@placements[bullet])
          if (ship = @placements[ship])
            ship.hit!
            if (ship.dead?)
              remove_later(ship)
              false
            end
          end
          true
        end
        @space.add_collision_func(:bullet, :bullet, &nil)
      end

      def place(entity)
        @placements[entity.shape] = entity
        @space.add_body(entity.body)
        @space.add_shape(entity.shape)
        notify(:placed, entity)
      end

      def remove(entity)
        return if entity.nil?
        @placements.delete(entity.shape)
        @space.remove_body(entity.shape.body)
        @space.remove_shape(entity.shape)
      end

      def remove_later(entity)
        @remove_list << entity
      end

      def do_removals
        @remove_list.each {|e| remove(e) }
        @remove_list = []
      end

      def each_entity
        @placements.values.each do |placement|
          yield placement
        end
      end

      def each_entity_with_box(left, top, right, bottom)
        bb = CP::BB.new(left, top, right, bottom)
        @space.bb_query(bb) do |shape|
          yield @placements[shape]
        end
      end

      def entity_count
        @placements.size
      end

      def update_physics(dt)
        @space.step(dt)
        do_removals
      end
    end
  end
end
