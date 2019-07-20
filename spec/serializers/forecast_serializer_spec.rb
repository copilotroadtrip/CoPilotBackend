require 'rails_helper'

describe 'Forecast Serializer Spec' do
  before :each do
    forecast_json = {
    "currently" => {
        "time" => 1563228791,
        "summary" => "Mostly Cloudy",
        "icon" => "partly-cloudy-day",
        "nearestStormDistance" => 12,
        "nearestStormBearing" => 37,
        "precipIntensity" => 0,
        "precipProbability" => 0,
        "temperature" => 81.99,
        "apparentTemperature" => 81.99,
        "dewPoint" => 49.94,
        "humidity" => 0.33,
        "pressure" => 1013.68,
        "windSpeed" => 13.17,
        "windGust" => 23.83,
        "windBearing" => 20,
        "cloudCover" => 0.75,
        "uvIndex" => 4,
        "visibility" => 3.141,
        "ozone" => 288.5
    },
    "hourly" => {
        "summary" => "Foggy this evening.",
        "icon" => "rain",
        "data" => [
            {
                "time" => 1563228000,
                "summary" => "Mostly Cloudy",
                "icon" => "partly-cloudy-day",
                "precipIntensity" => 0.001,
                "precipProbability" => 0.04,
                "precipType" => "rain",
                "temperature" => 82.52,
                "apparentTemperature" => 82.52,
                "dewPoint" => 49.61,
                "humidity" => 0.32,
                "pressure" => 1013.68,
                "windSpeed" => 12.67,
                "windGust" => 22.51,
                "windBearing" => 19,
                "cloudCover" => 0.74,
                "uvIndex" => 5,
                "visibility" => 3.588,
                "ozone" => 288.4
            },
            {
                "time" => 1563231600,
                "summary" => "Foggy",
                "icon" => "fog",
                "precipIntensity" => 0.004,
                "precipProbability" => 0.13,
                "precipType" => "rain",
                "temperature" => 80.11,
                "apparentTemperature" => 80.11,
                "dewPoint" => 51.11,
                "humidity" => 0.36,
                "pressure" => 1013.68,
                "windSpeed" => 14.95,
                "windGust" => 28.52,
                "windBearing" => 36,
                "cloudCover" => 0.78,
                "uvIndex" => 3,
                "visibility" => 1.554,
                "ozone" => 288.7
            }
          ]
        }
      }
    @fs = ForecastSerializer.new(forecast_json)
  end

  it 'serializes JSON forecast data into expected format' do
    current_forecast =   @fs.currently
    forecast_in_1_hour = @fs.hourly_in(1)

    expect(current_forecast['time']).to               be_an(Integer)
    expect(current_forecast['summary']).to            be_a(String)
    expect(current_forecast['icon']).to               be_a(String)
    expect(current_forecast['temperature']).to        be_a(Float).or(be_an(Integer))
    expect(current_forecast['precipProbability']).to  be_a(Float).or(be_an(Integer))
    expect(current_forecast['precipIntensity']).to    be_a(Float).or(be_an(Integer))
    expect(current_forecast['windSpeed']).to          be_a(Float).or(be_an(Integer))
    expect(current_forecast['windGust']).to           be_a(Float).or(be_an(Integer))
    expect(current_forecast['windBearing']).to        be_a(Float).or(be_an(Integer))

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

  it 'icons Happy Path - substitutes dashes with underscores' do
    forecast_json = {
      "currently" => {
        "icon" => "partly-cloudy-day"
        },
      "hourly" => {
        "data" => [
          {},
          {
          "icon" => "clear-night"
        }]
      }
    }

    fs = ForecastSerializer.new(forecast_json)

    expect(fs.currently['icon']).to eq('partly_cloudy_day')
    expect(fs.hourly_in(1)['icon']).to eq('clear_night')
  end

  it 'icons Sad Path - does not parse icons with no dashes' do
    forecast_json = {
      "currently" => {
        "icon" => "rain"
        },
      "hourly" => {
        "data" => [
          {},
          {
          "icon" => "snow"
        }]
      }
    }

    fs = ForecastSerializer.new(forecast_json)

    expect(fs.currently['icon']).to eq('rain')
    expect(fs.hourly_in(1)['icon']).to eq('snow')
  end

  it 'Sad path - Dark Sky API only returns hourly up to 48 hours' do
    forecast_in_49_hours = @fs.hourly_in(49)

    expect(forecast_in_49_hours).to eq({
      'error' => 'Weather API only returns out 48 hours'
    })
  end
end
