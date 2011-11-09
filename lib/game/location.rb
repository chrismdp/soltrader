module Spacestuff
  module Game
    class Location
      attr :name, :width, :height

      def initialize(options = {})
        @name = options[:name]
        @width = options[:width]
        @height = options[:height]
        @placements = []
        @space = CP::Space.new
        @space.damping = 0.8
      end

      def place(entity)
        @placements << entity
        @space.add_body(entity.body)
        @space.add_shape(entity.shape)
        #notify(:placed)
      end

      def each_entity
        @placements.each do |placement|
          yield placement
        end
      end

      def update_physics(dt)
        @space.step(dt)
      end
    end
  end
end
