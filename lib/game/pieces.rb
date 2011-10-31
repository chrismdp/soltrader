module Spacestuff
  module Game
    class ShipPiece
      attr :x
      attr :y

      def initialize(options)
        @x = options[:x]
        @y = options[:y]
      end
    end

    class HullPiece < ShipPiece
      def colour
        0xffffff00
      end
    end
  end
end
