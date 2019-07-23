require 'rails_helper'

describe 'Trip Pois API V1 requests', type: :request do
  describe 'POST /api/v1/trip_pois' do
    it 'Happy Path - valid params creates a trip_poi' do
      trip = Trip.create

      valid_params = {
        token: trip.token,
        trip_poi: {
         name: 'Denver',
         state: 'CO',
         population: 716492,
         lat: 39.914247,
         lng: -104.600302,
         sequence_number: 1,
         time_to_poi: 0.1
        }
      }

      post '/api/v1/trip_pois', params: valid_params

      expect(response).to be_successful
      expect(response.status).to eq(201)

      require "pry"; binding.pry
      expect(trip.trip_pois.count).to eq(1)
      trip_leg = trip.trip_pois.first

      expect(trip_leg.name).to eq(valid_params[:trip_poi][:name])
      expect(trip_leg.state).to eq(valid_params[:trip_poi][:state])
      expect(trip_leg.population).to eq(valid_params[:trip_poi][:population])
      expect(trip_leg.lat).to eq(valid_params[:trip_poi][:lat])
      expect(trip_leg.lng).to eq(valid_params[:trip_poi][:lng])
      expect(trip_leg.sequence_number).to eq(valid_params[:trip_poi][:sequence_number])
      expect(trip_leg.time_to_poi).to eq(valid_params[:trip_poi][:time_to_poi])
    end
  end
end
