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
    end
  end
end
