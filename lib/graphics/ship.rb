module Spacestuff
  module Graphics
    class Ship
      attr :image

      def self.graphics_for(ship)
        @ships ||= {}
        @ships[ship] ||= new(ship)
      end

      def initialize(ship)
        @image ||= SchematicRenderer.new(ship).render
      end

      def self.render(ship, viewport)
        @font ||= Gosu::Font.new($window, Gosu::default_font_name, 15)
        graphics_for(ship).image.draw_rot(ship.x - viewport.x, ship.y - viewport.y, 1, ship.angle * 180 / Math::PI + 90)
        #@font.draw(ship.lives.to_s + "#{ship.debug_message && " DBG: "+ship.debug_message}", ship.x - viewport.x, ship.y - viewport.y, 2)
      end
    end

    class Bullet
      def self.render(bullet, viewport)
        @animation ||= Chingu::Animation.new(:file => "smoke.png", :size => [128, 128], :delay => 20)
        @image ||= @animation.first
        color = Gosu::Color::WHITE.dup
        color.alpha = 255 - (bullet.percentage_lifetime * 255/100)
        @font ||= Gosu::Font.new($window, Gosu::default_font_name, 15)
        size = 0.25 + bullet.percentage_lifetime/200.0
        @image.draw_rot(bullet.x - viewport.x, bullet.y - viewport.y, 2, bullet.angle.to_degrees, 0.5, 0.5, size, size, color)
      end
    end
    class CelestialBody
      def self.render(body, viewport)
        @image ||= Image['earth.png']
        @image.draw_rot(body.x - viewport.x, body.y - viewport.y, -1, body.angle * 180 / Math::PI + 90)
      end
    end
  end
end
