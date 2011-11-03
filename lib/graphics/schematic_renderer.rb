module Spacestuff
  module Graphics
    class SchematicRenderer
      SCALE = 5
      def initialize(ship)
        @ship = ship
      end

      def render
        width, height = @ship.size
        TexPlay.create_blank_image($window, (width + 1) * SCALE, (height + 1) * SCALE).tap do |img|
          #debug_draw_border(img)
          @ship.pieces.each do |piece|
            piece.render(img)
          end
        end
      end

      def debug_draw_border(img)
        width, height = @ship.size
        img.rect 0, 0, (width + 1) * SCALE - 1, (height + 1) * SCALE - 1, :color => 0xffffcc00
      end

    end
  end
end
