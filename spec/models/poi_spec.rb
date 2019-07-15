require 'rails_helper'

RSpec.describe Poi, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :ne_latitude }
    it { should validate_presence_of :ne_longitude }
    it { should validate_presence_of :sw_latitude }
    it { should validate_presence_of :sw_longitude }
    it { should validate_presence_of :population }
    it { should validate_presence_of :state }
    it { should validate_presence_of :land_area }
    it { should validate_presence_of :total_area }
  end

  describe 'Relationships' do
    it { should have_many :trip_pois }
    it { should have_many(:trips).through(:trip_pois) }
  end
end
