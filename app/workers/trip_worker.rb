class TripWorker
  include Sidekiq::Worker

  def perform(steps, trip_token)
    url = 'https://poi-microservice.herokuapp.com/api/v1/build_trip'

    body = {
      steps: steps,
      token: trip_token
    }

    Faraday.post(url, body.to_json, "Content-Type" => "application/json")
  end
end
