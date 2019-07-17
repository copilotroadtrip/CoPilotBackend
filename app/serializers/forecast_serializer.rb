class ForecastSerializer
  attr_reader :forecast_json

  def initialize(forecast_json)
    @forecast_json = forecast_json
  end

  def currently
    c = forecast_json['currently']

    return {
      'time' =>              c['time'],
      'summary' =>           c['summary'],
      'icon' =>              c['icon'].gsub('-', '_'),
      'temperature' =>       c['temperature'],
      'precipProbability' => c['precipProbability'],
      'precipIntensity' =>   c['precipIntensity'],
      'windSpeed' =>         c['windSpeed'],
      'windGust' =>          c['windGust'],
      'windBearing' =>       c['windBearing']
    }
  end

  def hourly_in(hours_from_now)
    if hours_from_now > 48    # Dark Sky API only returns out 48 hours
      return {
        'error' => 'Weather API only returns out 48 hours'
      }
    end

    h = forecast_json['hourly']['data'][hours_from_now]

    return {
      'time' =>              h['time'],
      'summary' =>           h['summary'],
      'icon' =>              h['icon'].gsub('-', '_'),
      'temperature' =>       h['temperature'],
      'precipProbability' => h['precipProbability'],
      'precipIntensity' =>   h['precipIntensity'],
      'windSpeed' =>         h['windSpeed'],
      'windGust' =>          h['windGust'],
      'windBearing' =>       h['windBearing']
    }
  end
end
