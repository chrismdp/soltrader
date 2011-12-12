module Sol
  module Graphics
    module Utils
      def fade_color(entity)
        Gosu::Color::WHITE.dup.tap do |color|
          color.alpha = 255 - (entity.percentage_lifetime * 255/100)
        end
      end
    end

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
        graphics_for(ship).image.draw_rot(ship.x - viewport.x, ship.y - viewport.y, 1, ship.angle.to_degrees + 90)
        ship.place_smoke if (ship.fired_engines_this_frame)
        #@font ||= Gosu::Font.new($window, Gosu::default_font_name, 15)
        #@font.draw(ship.lives.to_s + "#{ship.debug_message && " DBG: "+ship.debug_message}", ship.x - viewport.x, ship.y - viewport.y, 2)
      end
    end

    class Bullet
      extend Utils
      def self.render(bullet, viewport)
        @image ||= Image['bullet.png']
        @image.draw_rot(bullet.x - viewport.x, bullet.y - viewport.y, 2, bullet.angle.to_degrees, 0.5, 0.5, 1, 1, fade_color(bullet))
      end
    end
    class Smoke
      extend Utils
      def self.render(smoke, viewport)
        @image ||= Image['smoke.png']
        size = 0.25 + smoke.percentage_lifetime/200.0
        @image.draw_rot(smoke.x - viewport.x, smoke.y - viewport.y, 2, smoke.angle.to_degrees, 0.5, 0.5, size, size, fade_color(smoke))
      end
    end
    class PurpleSmoke
      extend Utils
      def self.render(entity, viewport)
        @image ||= Image['smoke.png']
        size = 2 + entity.percentage_lifetime/200.0
        color = Gosu::Color::WHITE.dup.tap do |color|
          color.red = 0x6b
          color.green = 0x5c
          color.blue = 0xd2
          color.alpha = 255 - (entity.percentage_lifetime * 255/100)
        end
        @image.draw_rot(entity.x - viewport.x, entity.y - viewport.y, 2, entity.angle.to_degrees, 0.5, 0.5, size, size, color)
      end
    end
    class CelestialBody
      attr :image

      def self.graphics_for(body)
        @bodies ||= {}
        @bodies[body] ||= new(body)
      end

      def initialize(body)
        @image ||= Image[body.image]
      end

      def self.render(body, viewport)
        graphics_for(body).image.draw_rot(body.x - viewport.x, body.y - viewport.y, -1, body.angle.to_degrees + 90)
      end
    end

    class JumpGate
      def self.render(body, viewport)
        @image ||= Image['jumpgate.png']
        @image.draw_rot(body.x - viewport.x, body.y - viewport.y, 3, body.angle.to_degrees)
        body.add_spooky_purple_smoke
      end
    end
  end
end
