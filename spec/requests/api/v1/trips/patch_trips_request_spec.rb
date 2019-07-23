require 'rails_helper'

describe 'Trips API V1 requests', type: :request do
  describe 'PATCH /api/v1/trips' do
    it 'Happy Path - returns a successful response' do
      trip = Trip.create

      valid_params = {
        "token": trip.token,
        "status": "ready"
      }

      expect(trip.status).to eq('pending')

      patch '/api/v1/trips', params: valid_params

      trip.reload
      expect(trip.status).to eq('ready')

      expect(response).to be_successful
      expect(response.status).to eq(200)
    end

    it 'Sad Path - returns an invalid token message' do
      trip = Trip.create

      invalid_params = {
        "token": "invalid token",
        "status": "ready"
      }

      expect(trip.status).to eq('pending')

      patch '/api/v1/trips', params: invalid_params

      trip.reload
      expect(trip.status).to eq('pending')

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end
end
