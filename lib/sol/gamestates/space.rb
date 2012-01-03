module Sol
  module Gamestates
    class Space < Chingu::GameState
      trait :viewport


      def initialize(location, player_ship)
        super()

        @elapsed = 0

        @location = location
        @player_ship = player_ship

        self.viewport.lag = 0.95
        self.viewport.game_area = [0, 0, @location.width, @location.height]
        self.input = {
          :e => :attempt_interact,
          :holding_up => :go_faster,
          :holding_down => :go_slower,
          :holding_left => :turn_left,
          :holding_right => :turn_right,
          :space => :fire,
          :p => :pause
        }

        @stars = Graphics::BackgroundStars.new
      end


      def attempt_interact
        @player_ship.order :attempt_interact
      end

      def go_faster
        @player_ship.order :fire_main_engines
      end

      def go_slower
        @player_ship.order :fire_reverse_engines
      end

      def turn_left
        @player_ship.order :turn_left
      end

      def turn_right
        @player_ship.order :turn_right
      end

      def fire
        @player_ship.order :fire
      end

      def pause
        push_game_state(Chingu::GameStates::FadeTo.new(Chingu::GameStates::Pause, :speed => 30))
      end

      # stub implementation just return the equiv gfx object for now
      def graphics_class_for(entity, location)
        @klasses ||= {
          Sol::Game::Ship => Sol::Graphics::Ship,
          Sol::Game::Bullet => Sol::Graphics::Bullet,
          Sol::Game::Exhaust => Sol::Graphics::Smoke,
          Sol::Game::Mist => Sol::Graphics::PurpleSmoke,
          Sol::Game::Explosion => Sol::Graphics::Explosion,
          Sol::Game::CelestialBody => Sol::Graphics::CelestialBody,
          Sol::Game::JumpGate => Sol::Graphics::JumpGate
        }
        @klasses.fetch(entity.class)
      end

      def update
        @elapsed = $window.milliseconds_since_last_tick
        super
        @stars.update(viewport)
        self.viewport.center_around(@player_ship)
        if (@player_ship.landed?)
          gamestate = Sol::Gamestates::Planet.new(:planet => @player_ship.planet)
          push_game_state(gamestate)
        end
      end

      def draw
        super
        @stars.draw
        @font ||= Font["BebasNeue.otf", 75]

        if (@player_ship.in_gate?)
          @font.draw("Hyperspace", 200, 200, 2, 1, 1, 0xaaffffff)
          @font.draw("Jumping to #{@player_ship.destination}", 200, 250, 2, 1, 1, 0xaaffffff)
          @font.draw("ETA %.1f" % [@player_ship.time_to_destination_in_seconds], 200, 300, 2, 1, 1, 0xaaffffff)
          return
        end

        @location.each_entity_with_box(self.viewport.x - 256, self.viewport.y - 256, self.viewport.x + $window.width + 256, self.viewport.y + $window.height + 256) do |entity|
          graphics_class_for(entity, @location).render(entity, self.viewport)
        end
        Sol::Graphics::Ship.render_navigation_aids_for(@player_ship, viewport)
      end
    end
  end
end
