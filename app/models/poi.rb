class Poi < ApplicationRecord
  validates_presence_of :name,
                        :ne_latitude, :ne_longitude,
                        :sw_latitude, :sw_longitude
end
