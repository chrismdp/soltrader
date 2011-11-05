module Spacestuff
  module Game
    class ShipAi
      def initialize(options)
        @ship = options[:ship]
      end

      def update
        @ship.turn_left

      end

    end
  end
end
