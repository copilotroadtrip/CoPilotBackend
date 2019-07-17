require 'rails_helper'

describe 'Trips API V1 requests', type: :request do
  describe 'POST /api/v1/trips' do
    it 'Happy Path - returns a successful response' do
      VCR.use_cassette("requests/post_trips") do
        denver_poi = create(:poi,
          name: "Denver", state: "CO",
          ne_latitude: 39.914247, ne_longitude: -104.600302,
          sw_latitude: 39.614423, sw_longitude: -105.109924,
          population: 716492, land_area: "397024697", total_area: "401270097")

        seattle_poi = create(:poi,
        name: "Seattle", state: "WA",
        ne_latitude: 47.73528, ne_longitude: -122.219822,
        sw_latitude: 47.48215, sw_longitude: -122.459774,
        population: 744955, land_area: "217197934", total_area: "367953445")

        valid_params = {
           origin: 'Denver,CO',
           destination: 'Seattle,WA'
         }

        post '/api/v1/trips', params: valid_params

        expect(response).to be_successful
        expect(response.status).to eq(201)

        body = JSON.parse(response.body)

        expect(body['data']).to be_a(Hash)
        expect(body['data']['places']).to be_an(Array)

        expect(body['data']['places'].first['name']).to be_a(String)
        expect(body['data']['places'].last['name']).to be_a(String)

        expect(body['data']['places'].first['weather']).to be_a(Hash)
        expect(body['data']['places'].last['weather']).to be_a(Hash)

        expect(body['data']['legs']).to be_an(Array)
        expect(body['data']['legs'].first).to be_a(Hash)
        expect(body['data']['legs'].first['distance']).to be_a(String)
        expect(body['data']['legs'].first['duration_in_hours']).to be_a(Float)
      end
    end
  end
end