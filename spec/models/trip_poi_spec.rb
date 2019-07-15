require 'rails_helper'

RSpec.describe TripPoi, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :sequence_number }
  end

  describe 'Relationships' do
    it { should belong_to :trip }
    it { should belong_to :poi }
  end
end
