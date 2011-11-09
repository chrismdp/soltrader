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
        @space = CP::Space.new
        @space.damping = 0.8
        @space.add_collision_func(:ship, :bullet) do |ship, bullet|
          ship = @placements[ship]
          remove(ship) if ship
          bullet = @placements[bullet]
          remove(bullet) if bullet
        end
      end

      def place(entity)
        @placements[entity.shape] = entity
        @space.add_body(entity.body)
        @space.add_shape(entity.shape)
        notify(:placed, entity)
      end

      def remove(entity)
        @placements.delete(entity.shape)
        @space.remove_body(entity.shape.body)
        @space.remove_shape(entity.shape)
      end

      def each_entity
        @placements.values.each do |placement|
          yield placement
        end
      end

      def entity_count
        @placements.size
      end

      def update_physics(dt)
        @space.step(dt)
      end
    end
  end
end
