class TripLeg < ApplicationRecord
  validates_presence_of :sequence_number, :distance, :duration
  belongs_to :trip

  def to_json
    {
      'id':                 self.id,
      'sequence_number':    self.sequence_number,
      'distance':           self.distance,
      'duration_in_hours':  self.duration,
    }
  end
end
