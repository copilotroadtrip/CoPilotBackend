require 'rails_helper'

describe 'Dark Sky Service Spec' do
  it 'returns current weather data' do
   VCR.use_cassette("services/darksky/forecast") do
     lat = 39.614431
     lng = -105.109927

     service = DarkSkyService.new(lat, lng)

     expect(service.json).to be_a(Hash)

     expect(service.json['latitude']).to       be_a(Float).or(be_an(Integer))
     expect(service.json['longitude']).to      be_a(Float).or(be_an(Integer))
     expect(service.json['currently']).to      be_a(Hash)
     expect(service.json['hourly']).to         be_a(Hash)
     expect(service.json['hourly']['data']).to be_an(Array)
   end
  end

  it 'returns current weather with no lat/lng initially specified' do
   VCR.use_cassette("services/darksky/forecast") do
     lat = 39.614431
     lng = -105.109927

     service = DarkSkyService.new
     response = service.get(lat, lng)
     expect(response).to be_a(Hash)

     expect(response['latitude']).to       be_a(Float).or(be_an(Integer))
     expect(response['longitude']).to      be_a(Float).or(be_an(Integer))
     expect(response['currently']).to      be_a(Hash)
     expect(response['hourly']).to         be_a(Hash)
     expect(response['hourly']['data']).to be_an(Array)
   end
  end
end
