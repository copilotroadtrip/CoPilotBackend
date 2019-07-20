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

    # else... check if trip.status == "Pending"
      # Pending - Return Status 200 / JSON body of:
      # {"message": "trip pending"}

    # If valid trip_token AND trip.status == "Ready"
    # return all POIs and Legs


  end

  private
    def trip_params
      params.permit(:origin, :destination)
    end

    def trip_token_params
      params.permit(:token)
    end
end
