module Spacestuff
  module Gamestates
    class Space < Chingu::GameState
      trait :viewport
      def initialize
        super
        @current_location = Spacestuff::Game::Location.new(:name => "Earth Orbit", :width => 10000, :height => 10000)

        # earth = Spacestuff::Game::CelestialBody.new
        #current_location.place(earth, :x => 5000, :y => 5000)

        schematic = Spacestuff::Game::Schematic.new
        schematic.draw(Spacestuff::Game::HullPiece.new(:x => 0, :y => 0, :width => 48, :height => 48))
        schematic.draw(Spacestuff::Game::CockpitPiece.new(:x => 3, :y => 2, :width => 5, :height => 5))
        schematic.draw(Spacestuff::Game::EnginePiece.new(:x => 2, :y => 4, :width => 5, :height => 5))
        schematic.draw(Spacestuff::Game::EnginePiece.new(:x => 4, :y => 4, :width => 5, :height => 5))
        @player_ship = Spacestuff::Game::Ship.new(:schematic => schematic, :x => 5000, :y => 5050, :location => @current_location)

        50.times do
          Spacestuff::Game::Ship.new(:schematic => schematic, :x => rand(@current_location.width), :y => rand(@current_location.height), :location => @current_location, :ai => Spacestuff::Game::ShipAi.new)
        end

        self.viewport.lag = 0.95
        self.viewport.game_area = [0, 0, @current_location.width, @current_location.height]
        @current_location.each_entity do |entity|
         graphics_class_for(entity, @current_location).create(entity)
        end
        self.input = {
          :holding_up => :go_faster,
          :holding_down => :go_slower,
          :holding_left => :turn_left,
          :holding_right => :turn_right,
          :space => :fire
        }

        @stars = Graphics::BackgroundStars.new
      end

      def go_faster
        @player_ship.fire_main_engines
      end

      def go_slower
        @player_ship.fire_reverse_engines
      end

      def turn_left
        @player_ship.turn_left
      end

      def turn_right
        @player_ship.turn_right
      end

      def fire
        @player_ship.fire
      end

      # stub implementation just return the equiv gfx object for now
      def graphics_class_for(entity, location)
        {
          Spacestuff::Game::Ship => Spacestuff::Graphics::Ship,
        }[entity.class]
      end

      def update
        @current_location.each_entity do |entity|
          entity.update if entity.respond_to?(:update)
        end
        super
        @stars.update(viewport)
        self.viewport.center_around(@player_ship)
        $window.caption = "FPS: #{$window.fps} ms: #{$window.milliseconds_since_last_tick} GO: #{game_objects.size}"
        game_objects.destroy_if { |object| viewport.outside_game_area?(object) || object.color.alpha == 0 }
      end

      def draw
        @stars.draw
        super
      end
    end
  end
end
