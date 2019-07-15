class TripPoi < ApplicationRecord
  belongs_to :trip
  belongs_to :poi

  validates_presence_of :sequence_number
end
