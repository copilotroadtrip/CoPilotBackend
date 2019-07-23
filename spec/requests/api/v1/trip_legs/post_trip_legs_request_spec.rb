require 'rails_helper'

describe 'Trip Legs API V1 requests', type: :request do
  describe 'POST /api/v1/trip_legs' do
    it 'Happy Path - returns a successful response' do
      trip = Trip.create

      valid_params = {
        token: trip.token,
        distance: 100,
        duration: 200.0,
        sequence_number: 1
      }

      post '/api/v1/trip_legs', params: valid_params

      expect(response).to be_successful
      expect(response.status).to eq(201)

      expect(trip.trip_legs.count).to eq(1)
      trip_leg = trip.trip_legs.first

      expect(trip_leg.distance).to eq(100)
      expect(trip_leg.duration).to eq(200.0)
      expect(trip_leg.sequence_number).to eq(1)
    end

    it 'Sad Path - invalid token' do
      trip = Trip.create

      valid_params = {
        token: 'invalid token',
        distance: 100,
        duration: 200.0,
        sequence_number: 1
      }

      post '/api/v1/trip_legs', params: valid_params

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      expect(trip.trip_legs.count).to eq(0)
    end
  end
end
