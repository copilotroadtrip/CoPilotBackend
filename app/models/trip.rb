class Trip < ApplicationRecord
  has_many :trip_pois
  has_many :pois, through: :trip_pois

  validates_presence_of :token
end
