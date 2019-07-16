require 'rails_helper'

describe 'Trips API V1 requests', type: :request do
  describe 'POST /api/v1/trips' do
    it 'Happy Path - returns a successful response' do
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

      expect(body['data']['places'].first['name']).to eq(valid_params['origin'])
      expect(body['data']['places'].last['name']).to eq(valid_params['destination'])

      expect(body['data']['places'].first['weather']).to be_a(Hash)
      expect(body['data']['places'].last['weather']).to be_a(Hash)

      expect(body['data']['legs']).to be_an(Array)
      expect(body['data']['legs'].first).to be_a(Hash)
      expect(body['data']['legs'].first['distance']).to be_a(String)
      expect(body['data']['legs'].first['time']).to be_a(String)
    end
  end
end
# response:
# body:
# {
#     data: {
#         places: [
#             {
#                 "name": <origin name>,
#                 "population": <origin population>,
#                 "weather": { <origin weather object, temp, precip, etc>},
#             },
#             {
#                 "name": <destination name>,
#                 "population": <destination population>,
#                 "weather": { <dest. weath. obj. temp, precip etc}
#             }
#         ],
#         legs : [
#             {
#                 "distance": <distance b/w origin,destination>,
#                 "time": <time b/w or/dest>
#             }
#         ]
#     }
# }
