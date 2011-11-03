module Spacestuff
  module Game
    class Schematic
      def initialize
        @pieces = []
      end

      def draw(piece)
        @pieces << piece
      end

      def build(ship)
        @pieces.each do |piece|
          ship.bolt_on(piece)
        end
      end
    end
  end
end
