module Spacestuff
  module Gamestates
    class Space < Chingu::GameState
      trait :viewport
      def initialize
        super
        @current_location = Spacestuff::Game::Location.new(:name => "Earth Orbit", :width => 10000, :height => 10000)

        earth = Spacestuff::Game::CelestialBody.new(:position => vec2(5000,5000), :location => @current_location)
        jump_gate = Spacestuff::Game::JumpGate.new(:position => vec2(5000, 4500), :location => @current_location)

        @schematic = Spacestuff::Game::Schematic.new
        @schematic.draw(Spacestuff::Game::HullPiece.new(:x => 0, :y => 0, :width => 48, :height => 48))
        @schematic.draw(Spacestuff::Game::CockpitPiece.new(:x => 3, :y => 2, :width => 5, :height => 5))
        @schematic.draw(Spacestuff::Game::EnginePiece.new(:x => 2, :y => 4, :width => 5, :height => 5))
        @schematic.draw(Spacestuff::Game::EnginePiece.new(:x => 4, :y => 4, :width => 5, :height => 5))
        @player_ship = Spacestuff::Game::Ship.new(:schematic => @schematic, :x => 5000, :y => 5050, :location => @current_location)

        @minds = []
        add_ships(100)

        self.viewport.lag = 0.95
        self.viewport.game_area = [0, 0, @current_location.width, @current_location.height]
        self.input = {
          :holding_up => :go_faster,
          :holding_down => :go_slower,
          :holding_left => :turn_left,
          :holding_right => :turn_right,
          :space => :fire
        }

        @stars = Graphics::BackgroundStars.new
      end

      def add_ships(x)
        x.times do
          ship = Spacestuff::Game::Ship.new(:schematic => @schematic, :x => rand(3000) + 3500, :y => rand(3000) + 3500, :location => @current_location)
          actor = Spacestuff::Ai::Actor.new :behaviours => [:awol]
          actor.take_controls_of(ship)
          @minds << actor
        end
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

      # stub implementation just return the equiv gfx object for now
      def graphics_class_for(entity, location)
        {
          Spacestuff::Game::Ship => Spacestuff::Graphics::Ship,
          Spacestuff::Game::Bullet => Spacestuff::Graphics::Bullet,
          Spacestuff::Game::Exhaust => Spacestuff::Graphics::Bullet,
          Spacestuff::Game::CelestialBody => Spacestuff::Graphics::CelestialBody,
          Spacestuff::Game::JumpGate => Spacestuff::Graphics::JumpGate
        }.fetch(entity.class)
      end

      def update
        super
        elapsed = $window.milliseconds_since_last_tick
        @minds.each { |ai| ai.update(elapsed) }
        @current_location.update(elapsed)

        @stars.update(viewport)
        self.viewport.center_around(@player_ship)
        throttle(:caption, 1000, elapsed) do
          $window.caption = "FPS: #{$window.fps} #{$window.update_interval} ms: #{elapsed} Entities: #{@current_location.entity_count}"
        end
      end

      def draw
        super
        @stars.draw
        @current_location.each_entity_with_box(self.viewport.x - 256, self.viewport.y - 256, self.viewport.x + $window.width + 256, self.viewport.y + $window.height + 256) do |entity|
          graphics_class_for(entity, @location).render(entity, self.viewport)
        end
      end
    end
  end
end
