selector :root do
  priority { raise "should not be included as a child" }
end

selector :travel do
  priority { |actor| actor.destination ? 100 : 0 }
  children [:find_exit, :track_target]
end

selector :awol do
  # will be: actor.tagged?(:nutter) ? 100 : 0
  priority { 100 }
  children [ :find_any_target, :fire_at_target, :track_target ]
end

behaviour :idle do
  priority { 1 }
end

behaviour :find_exit do
  priority do |actor|
    next 0 if actor.current_target
    actor.destination ? 100 : 0
  end
  update do |elapsed|
    actor.acquire_target(:exit_to => actor.destination)
    DONE if actor.current_target
  end
end

behaviour :track_target do
  priority do |actor|
    actor.current_target ? 100 : 0
  end
  update do |elapsed|
    # Reducing gives the AI faster reactions.
    check_angle_every = 50
    # Reducing this makes the AI only fire when pointing directly
    # at the target.
    # Increasing will lead to 'spray'.
    accuracy_tolerance = 10.to_radians

    throttle(:find, check_angle_every, elapsed) do
      @angle_to = actor.ship.angle_to(actor.current_target)
    end

    if (@angle_to)
      actor.ship.debug_message = "track #{'%.2f' % @angle_to}"
      if (@angle_to < -accuracy_tolerance)
        actor.ship.order(:turn_left)
      elsif(@angle_to > accuracy_tolerance)
        actor.ship.order(:turn_right)
      else
        distance = actor.ship.squared_distance_to(actor.current_target)
        actor.ship.debug_message += ' dist %.2f' % Math.sqrt(distance)
        distance > 100 ** 2 ? actor.ship.order(:fire_main_engines) : actor.ship.order(:fire_reverse_engines)
        if distance > 75 ** 2 && distance < 250 ** 2
          next DONE
        end
      end
    end
  end
end

behaviour :find_any_target do
  priority do |actor|
    next 0 unless actor.ship
    actor.current_target && (!actor.current_target.dead?) ? 0 : 100
  end

  update do |elapsed|
    @wait_time ||= 0
    throttle(:find, @wait_time, elapsed) do
      @wait_time = rand(200) + 900
      @actor.acquire_target({})
    end
    DONE if @actor.current_target
  end
end

behaviour :fire_at_target do
  priority do |actor|
    # only for ships, currently
    next 0 unless actor.ship
    next 0 unless actor.current_target
    angle_diff = actor.ship.angle_to(actor.current_target)
    next 0 if (angle_diff < -5.to_radians || angle_diff > 5.to_radians)
    distance = actor.ship.squared_distance_to(actor.current_target)
    next 0 if distance > 250 ** 2 || distance < 75 ** 2
    100
  end

  update do |elapsed|
    @actor.ship.order(:fire)
    DONE
  end
end
