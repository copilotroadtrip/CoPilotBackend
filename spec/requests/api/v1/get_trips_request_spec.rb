require 'rails_helper'

describe 'Trips API V1 requests', type: :request do
  describe 'GET /api/v1/trips' do
    before :each do
      @trip = Trip.create
      @valid_params = { token: @trip.token }
    end

    it 'status 404 if an invalid trip token provided' do
      get '/api/v1/trips/', params: { token: "1234" }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      body = JSON.parse(response.body)

      expect(body['message']).to eq('Invalid Token')
    end

    it 'status 202 with pending message if trip.status is pending' do
      expect(@trip.status).to eq('pending')

      get '/api/v1/trips/', params: @valid_params

      expect(response).to be_successful
      expect(response.status).to eq(202)

      body = JSON.parse(response.body)

      expect(body['message']).to eq('Trip pending')
    end

    xit 'returns a successful response' do
      get '/api/v1/trips/', params: @valid_params

      expect(response).to be_successful
      expect(response.status).to eq(201)
    end
  end
end
