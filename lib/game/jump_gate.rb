module Spacestuff
  module Game
    class JumpGate
      attr :location

      include Spacestuff::Game::Physical
      def initialize(options = {})
        make_circle(100, 128)
        @location = options[:location]
        @location.place(self)
        @shape.layers = Physical::LAYER_SHIP
        @body.p = options[:position]
      end

      def update(elapsed)

      end

      def connect_to(other)
        raise ArgumentError unless @connected_gate.nil?
        raise ArgumentError if self == other
        raise ArgumentError if self.location == other.location
        @connected_gate = other
      end
    end
  end
end
