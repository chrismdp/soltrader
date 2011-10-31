module Spacestuff
  module Graphics
    class CelestialBody < Chingu::GameObject
      def self.create(options = {})
        super(options.merge(:image => Image["earth.png"]))
      end
    end
  end
end
