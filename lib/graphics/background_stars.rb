module Spacestuff
  module Graphics
    class BackgroundStars < Chingu::Parallax
      def initialize(options = {})
        super(options.merge(:x => 0, :y => 0, :rotation_center => :top_left))
        self << { :image => make_stars(20, 0xff333333), :repeat_x => true, :repeat_y => true, :damping => 6, :factor => 1, :zorder => -1 }
        self << { :image => make_stars(10, 0xff444444), :repeat_x => true, :repeat_y => true, :damping => 5.8, :factor => 1, :zorder => -1 }
        self << { :image => make_stars(2, 0x5fffffff), :repeat_x => true, :repeat_y => true, :damping => 1, :factor => 1 }
        self << { :image => make_stars(2, 0x5fffffff), :repeat_x => true, :repeat_y => true, :damping => 0.6, :factor => 1 }
      end

      def make_stars(count, colour)
        TexPlay.create_blank_image($window, 500, 500).tap do |img|
          count.times do
            x = rand(500)
            y = rand(500)
            img.rect x, y, x+4, y+4, :color => colour, :fill => true
          end
        end
      end

      def update(viewport)
        self.camera_x = viewport.x.to_i
        self.camera_y = viewport.y.to_i
        super()
      end
    end
  end
end
