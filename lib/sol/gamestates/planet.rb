module Sol
  module Gamestates
    class Planet < Chingu::GameState
      def initialize(options = {})
        super
        @big_font = Font["BebasNeue.otf", 100]
        @normal_font = Font["BebasNeue.otf", 50]
        @planet = options[:planet] or raise "No planet given!"
        @text_color = Gosu::Color.new(180, 255, 255, 255)
        @background = Image['earth_surface.png']
      end

      def draw
        @background.draw_rot(0, 0, 0, 0, 0, 0, 1, 1, 0x99ffffff)

        @big_font.draw("Welcome to #{@planet.name}", 100, 125, 2, 1, 1, @text_color)
        @normal_font.draw("1.   Trade at the market", 200, 300, 2, 1, 1, @text_color)
        @normal_font.draw("2.   Visit the shipyard", 200, 360, 2, 1, 1, @text_color)
        @normal_font.draw("3.   Head to the bar", 200, 420, 2, 1, 1, @text_color)
        @normal_font.draw("4.   Leave this planet", 200, 480, 2, 1, 1, @text_color)
      end
    end
  end
end
