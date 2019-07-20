class ForecastSerializer
  attr_reader :forecast_json

  def initialize(forecast_json)
    @forecast_json = forecast_json
  end

  def currently
    hourly_in(0)
  end

  def hourly_in(hours_from_now)
    if hours_from_now > 48    # Dark Sky API only returns out 48 hours
      return {
        'error' => 'Weather API only returns out 48 hours'
      }
    elsif hours_from_now == 0
      h = forecast_json['currently']
    else
      h = forecast_json['hourly']['data'][hours_from_now]
    end
    
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
