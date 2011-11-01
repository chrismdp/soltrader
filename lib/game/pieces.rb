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
        0xff999999
      end
    end

    class CockpitPiece < ShipPiece
      def colour
        0xff66ccff
      end
    end

    class EnginePiece < ShipPiece
      def colour
        0xff993300
      end
    end
  end
end
