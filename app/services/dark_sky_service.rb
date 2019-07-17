class DarkSkyService
  # Dark Sky API only returns out 48 hours

  attr_reader :latitude, :longitude

  def initialize(latitude = nil, longitude = nil)
    @latitude = latitude
    @longitude = longitude
  end

  def conn
    @_conn ||= Faraday.new("https://api.darksky.net/forecast/#{ENV['DARK_SKY_APIKEY']}/") do |f|
      f.adapter Faraday.default_adapter
    end
  end

  def get(latitude, longitude)
    JSON.parse(conn.get("#{latitude},#{longitude}").body)
  end

  def response
    @_response ||= conn.get("#{latitude},#{longitude}")
  end

  def json
    JSON.parse(response.body)
  end
end
