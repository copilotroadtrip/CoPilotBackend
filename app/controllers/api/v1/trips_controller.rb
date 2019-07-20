class Api::V1::TripsController < ActionController::API
  def create
    render json: TripFacade.new(trip_params).response, status: 201
  end

  def index
    # Lookup trip by token
    trip = Trip.find_by(token: trip_token_params[:token])

    # If no trip exists, invalid trip_token
    unless trip
      render json: { message: 'Invalid Token'}, status: 404
    end

    # If valid trip AND trip.status == 'pending', POI data is not yet ready
    if trip && trip.pending?
      render json: { message: 'Trip pending'}, status: 202
    end

    # If valid trip AND trip.status == "Ready", return all POIs and Legs
    if trip && trip.ready?
      render json: TripLegsFacade.new(trip).response, status: 200
    end
  end

  private
    def trip_params
      params.permit(:origin, :destination)
    end

    def trip_token_params
      params.permit(:token)
    end
end
