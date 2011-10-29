module Spacestuff
  module Gamestates
    class Space < Chingu::GameState
      def initialize
        super

        @player = Player.create(:x => 200, :y => 200, :image => Image[ "spaceship.png" ])
        @player.input = {
          :holding_up => :go_faster,
          :holding_down => :go_slower,
          :holding_left => :turn_left,
          :holding_right => :turn_right
        }
      end
    end
  end
end
