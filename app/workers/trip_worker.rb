class TripWorker
  include Sidekiq::Worker

  def perform(trip_id)
    trip = Trip.find(trip_id.to_i)

    body = {
      steps: trip.steps,
      token: trip.token
    }

    url = 'http://127.0.0.1:9393/api/v1/build_trip' # https://poi-microservice.herokuapp.com

    Faraday.post(url, body.to_json, "Content-Type" => "application/json")
  end
end
