module Sol
  module Game
    class Lifespan
      def initialize(total_life)
        @total_life = total_life
        @remaining_life = total_life
      end

      def percentage_lifetime
        100 - @remaining_life * 100 / @total_life
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
