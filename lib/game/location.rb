module Spacestuff
  module Game
    class Location
      attr :name, :width, :height

      def initialize(options = {})
        @name = options[:name]
        @width = options[:width]
        @height = options[:height]
        @placements = []
      end

      def place(entity)
        @placements << entity
      end

      def each_entity
        @placements.each do |placement|
          yield placement
        end
      end

    end
  end
end
