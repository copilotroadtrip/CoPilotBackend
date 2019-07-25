class TripLeg < ApplicationRecord
  validates_presence_of :sequence_number, :distance, :duration
  belongs_to :trip

  def to_json
    {
      'id':                 self.id,
      'sequence_number':    self.sequence_number,
      'distance':           distance_patch,
      'duration_in_hours':  self.duration,
    }
  end

  # Converts to mileage due to inconsistency
  # poi-microservice is serving distance up as an integer `meters`
  # this will catch that and convert to miles
  def distance_patch
    if self.distance.class == String # Already formatted as miles
      return self.distance
    else
      miles = ( self.distance / 1609.34 ).round # 1609.34 meters per mile
      return miles.to_s + ' mi'
    end
  end
end
