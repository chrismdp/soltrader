module Spacestuff
  module Game
    class Location
      attr :x
      attr :y

      def initialize(x, y)
        @x = x
        @y = y
      end
    end
  end
end
