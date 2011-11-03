module Spacestuff
  module Graphics
    class SchematicRenderer
      def initialize(ship)
        @ship = ship
      end

      def render
        width, height = @ship.size
        TexPlay.create_blank_image($window, width, height).tap do |img|
          #debug_draw_border(img)
          @ship.pieces.each do |piece|
            piece.render(img)
          end
        end
      end

      def debug_draw_border(img)
        width, height = @ship.size
        img.rect 0, 0, width, height, :color => 0xffffcc00
      end

    end
  end
end
