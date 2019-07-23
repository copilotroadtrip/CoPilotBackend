class Api::V1::TripsController < ActionController::API
  def create
    render json: TripFacade.new(trip_params).response, status: 201
  end

  def index
    # Lookup trip by token
    trip = Trip.find_by(token: trip_token_params[:token])

    # If no trip exists, invalid trip_token
    if !trip
      render json: { message: 'Invalid Token'}, status: 404

    # If valid trip AND trip.status == 'pending', POI data is not yet ready
    elsif trip.pending?
      render json: { message: 'Trip pending'}, status: 202

    # If valid trip AND trip.status == "Ready", return all POIs and Legs
    elsif trip.ready?
      render json: TripLegsFacade.new(trip).response, status: 200
    end
  end

  def update
    trip = Trip.find_by(token: update_params[:token])

    if !trip
      render json: { message: 'Invalid Token'}, status: 404
    else
      trip.status = 'ready'
      trip.save

      render json: { message: 'Success' }, status: 200
    end
  end

  private
    def trip_params
      params.permit(:origin, :destination)
    end

    def trip_token_params
      params.permit(:token)
    end

    def update_params
      params.permit(:token, :status)
    end
end
