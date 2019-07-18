require 'rails_helper'

RSpec.describe TripWeather, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :time }
    it { should validate_presence_of :summary }
    it { should validate_presence_of :temperature }
    it { should validate_presence_of :precipProbability }
    it { should validate_presence_of :precipIntensity }
    it { should validate_presence_of :windSpeed }
    it { should validate_presence_of :windGust }
    it { should validate_presence_of :windBearing }
    it { should validate_presence_of :icon }
  end

  describe 'Relationships' do
    it {should belong_to :trip }
  end
end
