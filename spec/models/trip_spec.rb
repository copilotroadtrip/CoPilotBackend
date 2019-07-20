require 'rails_helper'

RSpec.describe Trip, type: :model do
  describe 'Validations' do
    it { should define_enum_for :status }
  end

  describe 'Relationships' do
    it { should have_many :trip_pois }
    it { should have_many :trip_legs }
    it { should have_many(:pois).through(:trip_pois) }
  end

  it 'Trip creation generates token, sets status' do
    trip = Trip.create
    expect(trip.token).not_to eq(nil)
    expect(trip.status).to eq("pending")
  end
end
