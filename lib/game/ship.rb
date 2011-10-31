module Spacestuff
  module Game
    class Ship
      attr :location, :pieces

      def initialize(location)
        @location = location
        @pieces = []
      end

      def rate_of_acceleration
        0.2
      end

      def rate_of_braking
        0.05
      end

      def bolt_on(piece)
        @pieces << piece
      end

      def size
        x, y = [], []
        pieces.map do |piece|
          x << piece.x
          y << piece.y
        end
        [x.max, y.max]
      end
    end
  end
end
