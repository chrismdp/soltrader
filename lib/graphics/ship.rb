module Spacestuff
  module Graphics
    class Ship < Chingu::GameObject
      def initialize(ship)
        @ship = ship
        super({
          :x => @ship.shape.body.p.x,
          :y => @ship.shape.body.p.y
        }.merge(:image => image))
      end

      def image
        @image ||= SchematicRenderer.new(@ship).render
      end

      def update
        @angle = @ship.angle * 180.0 / Math::PI + 90
        @x, @y = @ship.shape.body.p.x, @ship.shape.body.p.y
      end
    end

    class Bullet < Chingu::GameObject
      def initialize(bullet)
        @bullet = bullet
        super({
          :x => @bullet.shape.body.p.x,
          :y => @bullet.shape.body.p.y
        })
        @animation = Chingu::Animation.new(:file => "fireball.png", :size => [32,32], :delay => 20)
        @image = @animation.first
      end

      def update
        @angle = @bullet.angle * 180.0 / Math::PI + 90
        @x, @y = @bullet.shape.body.p.x, @bullet.shape.body.p.y
        @image = @animation.next
      end
    end

  end
end
