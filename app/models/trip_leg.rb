class TripLeg < ApplicationRecord
  validates_presence_of :sequence_number, :distance, :duration
  belongs_to :trip

end
