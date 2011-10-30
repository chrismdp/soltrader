module Spacestuff
  class BackgroundStars < Chingu::GameObject
    def initialize(options)
      super
      @image = TexPlay.create_blank_image($window, 500, 500, :factor => 4)
      500.times do
        @image.pixel rand(500), rand(500), :color => 0x7fffffff
      end
    end
  end
end
