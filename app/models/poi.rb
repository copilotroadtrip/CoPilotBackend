class Poi < ApplicationRecord
  has_many :trip_pois
  has_many :trips, through: :trip_pois

  validates_presence_of :name,
                        :ne_latitude, :ne_longitude,
                        :sw_latitude, :sw_longitude
end
