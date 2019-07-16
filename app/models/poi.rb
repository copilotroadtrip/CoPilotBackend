class Poi < ApplicationRecord
  has_many :trip_pois
  has_many :trips, through: :trip_pois

  validates_presence_of :name, :population, :state,
                        :land_area, :total_area,
                        :ne_latitude, :ne_longitude,
                        :sw_latitude, :sw_longitude

  def self.poi_at_location(lat, lng)
    Poi
      .where('ne_latitude > ?', lat)
      .where('sw_latitude < ?', lat)
      .where( 'sw_longitude < ?', lng)
      .where('ne_longitude > ?', lng)
  end
end
