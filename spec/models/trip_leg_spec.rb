require 'rails_helper'

RSpec.describe TripLeg, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :sequence_number }
    it { should validate_presence_of :distance }
    it { should validate_presence_of :duration }
  end

  describe 'Relationships' do
    it {should belong_to :trip }
  end
end
