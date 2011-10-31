module Spacestuff
  module Game
    class Location

      def initialize(options = {})
        @x = options[:x]
        @y = options[:y]
        @parent = options[:parent]
      end

      def x
        delta = @parent ? @parent.x : 0
        @x + delta
      end

      def y
        delta = @parent ? @parent.y : 0
        @y + delta
      end
      
    end
  end
end
