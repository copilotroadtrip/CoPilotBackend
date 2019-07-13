class GoogleMapsService
  attr_reader :origin, :destination

  def initialize(origin, destination)
    @origin = origin
    @destination = destination
  end

  def conn
    @_conn ||= Faraday.new('https://maps.googleapis.com/maps/api/directions/json') do |f|
      f.adapter Faraday.default_adapter
      f.params['key'] = ENV['GOOGLE_MAPS_APIKEY']
    end
  end

  def response
    @_response ||= conn.get do |req|
      req.params['origin'] = origin
      req.params['destination'] = destination
    end
  end
end
