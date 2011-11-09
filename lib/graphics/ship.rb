module Spacestuff
  module Graphics
    class Ship
      def self.render(ship, viewport)
        @image ||= SchematicRenderer.new(ship).render
        if (viewport.inside?(ship))
          @image.draw_rot(ship.x - viewport.x, ship.y - viewport.y, 1, ship.angle * 180 / Math::PI + 90)
        end
      end
    end

    class Bullet
      def self.render(bullet, viewport)
        @animation ||= Chingu::Animation.new(:file => "fireball.png", :size => [32,32], :delay => 20)
        @image ||= @animation.first
        @image = @animation.next
        if (viewport.inside?(bullet))
          @image.draw_rot(bullet.x - viewport.x, bullet.y - viewport.y, 1, bullet.angle * 180 / Math::PI + 90)
        end
      end
    end
  end
end
