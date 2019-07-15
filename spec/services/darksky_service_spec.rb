require 'rails_helper'

describe 'Dark Sky Service Spec' do
  it 'returns current weather data' do
   VCR.use_cassette("services/darksky/forecast") do
     lat = 39.614431
     long = -105.109927

     service = DarkSkyService.new(lat, long)

     current_forecast = service.forecast_currently

     expect(current_forecast['time']).to               be_an(Integer)
     expect(current_forecast['summary']).to            be_a(String)
     expect(current_forecast['icon']).to               be_a(String)
     expect(current_forecast['temperature']).to        be_a(Float).or(be_an(Integer))
     expect(current_forecast['precipProbability']).to  be_a(Float).or(be_an(Integer))
     expect(current_forecast['precipIntensity']).to    be_a(Float).or(be_an(Integer))
     expect(current_forecast['windSpeed']).to          be_a(Float).or(be_an(Integer))
     expect(current_forecast['windGust']).to           be_a(Float).or(be_an(Integer))
     expect(current_forecast['windBearing']).to        be_a(Float).or(be_an(Integer))

     forecast_in_1_hour = service.forecast_hourly_in(1)

     expect(forecast_in_1_hour['time']).to               be_an(Integer)
     expect(forecast_in_1_hour['summary']).to            be_a(String)
     expect(forecast_in_1_hour['icon']).to               be_a(String)
     expect(forecast_in_1_hour['temperature']).to        be_a(Float).or(be_an(Integer))
     expect(forecast_in_1_hour['precipProbability']).to  be_a(Float).or(be_an(Integer))
     expect(forecast_in_1_hour['precipIntensity']).to    be_a(Float).or(be_an(Integer))
     expect(forecast_in_1_hour['windSpeed']).to          be_a(Float).or(be_an(Integer))
     expect(forecast_in_1_hour['windGust']).to           be_a(Float).or(be_an(Integer))
     expect(forecast_in_1_hour['windBearing']).to        be_a(Float).or(be_an(Integer))
   end
  end
end
