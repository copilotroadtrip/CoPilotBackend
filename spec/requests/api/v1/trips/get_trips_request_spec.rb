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

    it 'status 200 if trip.status is ready' do
      @trip.status = 1
      @trip.save
      expect(@trip.status).to eq('ready')

      get '/api/v1/trips/', params: @valid_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      # See trip_legs_facade_spec.rb for more thorough
      # testing on the payload of this response
    end
  end
end
