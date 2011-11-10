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
        @font.draw(ship.lives, ship.x - viewport.x, ship.y - viewport.y, 2)
      end
    end

    class Bullet
      def self.render(bullet, viewport)
        @animation ||= Chingu::Animation.new(:file => "fireball.png", :size => [32,32], :delay => 20)
        @image ||= @animation.first
        color = Gosu::Color::WHITE.dup
        color.alpha = 255 - (bullet.percentage_lifetime * 255)
        @font ||= Gosu::Font.new($window, Gosu::default_font_name, 15)
        @image.draw_rot(bullet.x - viewport.x, bullet.y - viewport.y, 1, bullet.angle * 180 / Math::PI + 90, 0.5, 0.5, 0.5 + bullet.percentage_lifetime, 0.5 + bullet.percentage_lifetime, color)
      end
    end
  end
end
