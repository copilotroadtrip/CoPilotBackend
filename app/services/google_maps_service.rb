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

  def json
    JSON.parse(response.body)
  end

  def steps
    json['routes'][0]['legs'][0]['steps']
  end

  def route_coordinates
    coordinates = []

    steps.each do |step|
      polyline = step['polyline']['points']
      p_decoded = Polylines::Decoder.decode_polyline(polyline)    # Gem that decodes polyline string into an array of long/lat coords
      coordinates += p_decoded
    end

    coordinates
  end

  def leg_info
    json['routes'][0]['legs'][0]
  end

  def start_address
    leg_info['start_address']
  end

  def start_lat
    leg_info['start_location']['lat']
  end

  def start_lng
    leg_info['start_location']['lng']
  end

  def end_address
    leg_info['end_address']
  end

  def end_lat
    leg_info['end_location']['lat']
  end

  def end_lng
    leg_info['end_location']['lng']
  end
  
  def distance_text
    leg_info['distance']['text']
  end

  def duration_seconds
    leg_info['duration']['value']
  end

  def duration_hours
    (duration_seconds / 3600.0)
  end
end
