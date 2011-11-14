module Spacestuff
  module Game
    class Lifespan
      def initialize(total_life)
        @total_life = total_life
        @remaining_life = total_life
      end

      def percentage_lifetime
        1 - @remaining_life.to_f / @total_life.to_f
      end

      def update(elapsed)
        @remaining_life -= elapsed
      end

      def finished?
        @remaining_life <= 0
      end
    end
  end
end
