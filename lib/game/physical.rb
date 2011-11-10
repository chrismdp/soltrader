module Spacestuff
  module Game
    module Physical
      def self.included(klass)
        class_eval { attr :shape, :body }
      end
      def x
        @body.p.x
      end
      def y
        @body.p.y
      end
      def angle
        @body.a
      end
    end
  end
end
