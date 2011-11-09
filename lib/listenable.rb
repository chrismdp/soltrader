module Spacestuff
  module Listenable
    # listening
    def listen(listener, event)
      @listeners ||= Hash.new([])
      @listeners[event].push(listener)
    end

    def notify(event)
      if @listeners && listeners_for_event = @listeners[event]
        listeners_for_event.each { |listener| listener.send(event) }
      end
    end
  end
end
