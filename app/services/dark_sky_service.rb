class DarkSkyService
  # Dark Sky API only returns out 48 hours

  attr_reader :latitude, :longitude

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def conn
    @_conn ||= Faraday.new("https://api.darksky.net/forecast/#{ENV['DARK_SKY_APIKEY']}/") do |f|
      f.adapter Faraday.default_adapter
    end
  end

  def response
    @_response ||= conn.get("#{latitude},#{longitude}")
  end

  def json
    JSON.parse(response.body)
  end

  def forecast_currently
    c = json['currently']

    return {
      'time' =>              c['time'],
      'summary' =>           c['summary'],
      'icon' =>              c['icon'],
      'temperature' =>       c['temperature'],
      'precipProbability' => c['precipProbability'],
      'precipIntensity' =>   c['precipIntensity'],
      'windSpeed' =>         c['windSpeed'],
      'windGust' =>          c['windGust'],
      'windBearing' =>       c['windBearing']
    }
  end

  def forecast_hourly_in(hours_from_now)
    h = json['hourly']['data'][hours_from_now]

    return {
      'time' =>              h['time'],
      'summary' =>           h['summary'],
      'icon' =>              h['icon'],
      'temperature' =>       h['temperature'],
      'precipProbability' => h['precipProbability'],
      'precipIntensity' =>   h['precipIntensity'],
      'windSpeed' =>         h['windSpeed'],
      'windGust' =>          h['windGust'],
      'windBearing' =>       h['windBearing']
    }
  end
end
