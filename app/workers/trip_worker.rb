class TripWorker
  include Sidekiq::Worker

  def perform(trip_id)
    trip = Trip.find(trip_id)

    body = {
      steps: trip.steps,
      token: trip.token
    }

    url = 'https://poi-microservice.herokuapp.com/api/v1/build_trip'

    Faraday.post(url, body.to_json, "Content-Type" => "application/json")
  end
end
