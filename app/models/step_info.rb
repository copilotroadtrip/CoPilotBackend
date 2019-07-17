class StepInfo
  attr_reader :dist, :time, :speed

  def initialize(step)
    @dist = step_dist(step)
    @time = step_time(step)
    @speed = step_speed(step)
  end

  private

  def step_speed(step)
    step_dist(step) / step_time(step).to_f
  end

  def step_dist(step)
    step['distance']['value']
  end

  def step_time(step)
    step['duration']['value']
  end
end
