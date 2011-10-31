module Spacestuff
  module Game
    class Ship
      attr :location

      def initialize(location)
        @location = location
      end

      def rate_of_acceleration
        0.2
      end

      def rate_of_braking
        0.05
      end
    end
  end
end
