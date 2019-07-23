require 'rails_helper'

describe 'Trips API V1 requests', type: :request do
  describe 'PATCH /api/v1/trips' do
    it 'Happy Path - returns a successful response' do
      trip = Trip.create

      valid_params = {
        "token": "tripToken",
        "status": "ready"
      }

      expect(trip.status).to eq('pending')

      patch '/api/v1/trips', params: valid_params

      expect(trip.status).to eq('ready')

      expect(response).to be_successful
      expect(response.status).to eq(200)
    end
  end
end
