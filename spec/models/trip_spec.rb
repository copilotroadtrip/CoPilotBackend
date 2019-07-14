require 'rails_helper'

RSpec.describe Trip, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :token }
  end

  describe 'Relationships' do
    it { should have_many :trip_pois }
    it { should have_many(:pois).through(:trip_pois) }
  end
end
