module Sol
  module Game
    module Gate
      def self.included(klass)
        klass.extend(self)
      end

      def self.extended(thing)
        class_eval do
          attr :location, :jumping
        end
      end

      def initialize(options)
        super
        @jumping = []
        @total_seconds_elapsed = 0
        @jump_seconds = options[:jump_seconds] || 5
      end

      def update(elapsed)
        super
        @total_seconds_elapsed += elapsed / 1000.0

        @jumping.each do |arrival_time, jumper|
          if arrival_time < @total_seconds_elapsed
            after_move_to(jumper)
            @jumping.shift
          else
            break
          end
        end
        # FIXME: Not happy about this boolean primitive here: should return REMOVE or similar
        return false
      end

      def time_to(time)
        time - @total_seconds_elapsed
      end

      def move_from(ship)
        destination_time = @total_seconds_elapsed + @jump_seconds
        @jumping << [destination_time, ship]
        after_move_from(ship, destination_time)
      end

      def move_to(ship)
      end
    end
  end
end
