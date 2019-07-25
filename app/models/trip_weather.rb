class TripWeather < ApplicationRecord
  validates_presence_of :time, :summary, :temperature, :precipProbability,
    :precipIntensity, :windSpeed, :windGust, :windBearing, :icon

  # belongs_to :trip
end
