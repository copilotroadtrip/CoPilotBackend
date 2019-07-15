require 'rails_helper'

describe 'Dark Sky Service Spec' do
  it 'returns current weather data' do
   VCR.use_cassette("services/darksky/forecast") do
     lat = 39.614431
     long = -105.109927

     service = DarkSkyService.new(lat, long)

     expect(service.json).to be_a(Hash)

     expect(service.json['latitude']).to       be_a(Float).or(be_an(Integer))
     expect(service.json['longitude']).to      be_a(Float).or(be_an(Integer))
     expect(service.json['currently']).to      be_a(Hash)
     expect(service.json['hourly']).to         be_a(Hash)
     expect(service.json['hourly']['data']).to be_an(Array)
   end
  end
end
