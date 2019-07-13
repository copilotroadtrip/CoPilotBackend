require 'rails_helper'

describe 'Google Maps Service Spec' do
  it 'returns data' do
   VCR.use_cassette("services/google_maps/directions") do
      origin = 'Denver,CO'
      destination = 'Seattle,WA'

      gs = GoogleMapsService.new(origin, destination)

      expect(gs.response).to eq('blah')
    end
  end
end
