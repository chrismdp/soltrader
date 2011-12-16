class Object
  def throttle(label, every, elapsed)
    @throttles ||= Hash.new(0)
    @throttles[label] += elapsed
    if @throttles[label] > every
      @throttles[label] = 0
      yield
    end
  end
end
