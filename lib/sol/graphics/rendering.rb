module Sol
  module Graphics
    module Utils
      def fade_color(entity)
        Gosu::Color::WHITE.dup.tap do |color|
          if (entity.percentage_lifetime < 10)
            color.alpha = (255 * entity.percentage_lifetime / 10)
          else
            color.alpha = 255 - (entity.percentage_lifetime * 255/100)
          end
        end
      end
    end

    GUI_LAYER = 100
    SHIP_LAYER = 1
    EFFECTS_LAYER = 2
    CELESTIAL_BODY_LAYER = -1
    JUMP_GATE_LAYER = 3

    class Ship
      attr :image

      def self.graphics_for(ship)
        @ships ||= {}
        @ships[ship] ||= new(ship)
      end

      def initialize(ship)
        @image ||= SchematicRenderer.new(ship).render
      end

      RIM_WIDTH = SCREEN_WIDTH - 110
      RIM_HEIGHT = SCREEN_HEIGHT - 30
      def self.render(ship, viewport)
        @font ||= Font["BebasNeue.otf", 25]
        ship.place_smoke if (ship.fired_engines_this_frame)
        size = 1
        if (ship.entering_atmosphere?)
          # FIXME: Relies on the time to enter the planet to be 5 seconds
          size = ((ship.time_to_destination_in_seconds+2)/7.0)
          ship.place_heat_shield_smoke
          @font.draw("RE-ENTRY IN %1.f" % ship.time_to_destination_in_seconds, ship.x - viewport.x + 10, ship.y - viewport.y + 10, GUI_LAYER)
        end
        graphics_for(ship).image.draw_rot(ship.x - viewport.x, ship.y - viewport.y, SHIP_LAYER, ship.angle.to_degrees + 90, 0.5, 0.5, size, size)

        # Show navigation bits prototype
        ship.location.each_entity do |entity|
          next if !entity.is_a?(Sol::Game::Gate)
          x = entity.x - viewport.x
          x = (x < 10 ? 10: x)
          x = (x > RIM_WIDTH ? RIM_WIDTH : x)
          y = entity.y - viewport.y
          y = (y < 20 ? 20: y)
          y = (y > RIM_HEIGHT ? RIM_HEIGHT : y)
          @font.draw("#{entity.destination}", x, y, GUI_LAYER, 1, 1, Gosu::Color.new(0x99ffffff))
        end
      end
    end

    class Bullet
      extend Utils
      def self.render(bullet, viewport)
        @image ||= Image['bullet.png']
        @image.draw_rot(bullet.x - viewport.x, bullet.y - viewport.y, EFFECTS_LAYER, bullet.angle.to_degrees, 0.5, 0.5, 1, 1, fade_color(bullet))
      end
    end
    class Smoke
      extend Utils
      def self.render(smoke, viewport)
        @image ||= Image['smoke.png']
        size = 0.25 + smoke.percentage_lifetime/200.0
        @image.draw_rot(smoke.x - viewport.x, smoke.y - viewport.y, EFFECTS_LAYER, smoke.angle.to_degrees, 0.5, 0.5, size, size, fade_color(smoke))
      end
    end
    class PurpleSmoke
      extend Utils
      def self.render(entity, viewport)
        @image ||= Image['smoke.png']
        size = 2 + entity.percentage_lifetime/200.0
        color = fade_color(entity).tap do |color|
          color.red = 0x6b
          color.green = 0x5c
          color.blue = 0xd2
        end
        @image.draw_rot(entity.x - viewport.x, entity.y - viewport.y, EFFECTS_LAYER, entity.angle.to_degrees, 0.5, 0.5, size, size, color, :additive)
      end
    end
    class Explosion
      extend Utils
      def self.render(entity, viewport)
        @image ||= Image['smoke.png']
        color = fade_color(entity).tap do |color|
          color.red = 0xff
          color.green = 0x33
          color.blue = 0x33
        end
        @image.draw_rot(entity.x - viewport.x, entity.y - viewport.y, 0, entity.angle.to_degrees, 0.5, 0.5, 0.75, 0.75, color, :additive)
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
        graphics_for(body).image.draw_rot(body.x - viewport.x, body.y - viewport.y, CELESTIAL_BODY_LAYER, body.angle.to_degrees + 90)
      end
    end

    class JumpGate
      def self.render(body, viewport)
        @image ||= Image['jumpgate.png']
        @image.draw_rot(body.x - viewport.x, body.y - viewport.y, JUMP_GATE_LAYER, body.angle.to_degrees)
        body.add_spooky_purple_smoke
      end
    end
  end
end
