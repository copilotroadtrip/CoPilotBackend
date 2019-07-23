class Api::V1::TripLegsController < ActionController::API
  def create
    trip = Trip.find_by(token: new_params[:token])

    if !trip
      render json: { message: 'Invalid Token'}, status: 404
    else
      trip.trip_legs.create(new_trip_leg_params)

      render json: { message: 'Success' }, status: 201
    end
  end

  private
    def new_params
      params.permit(:token, :distance, :duration, :sequence_number)
    end

    def new_trip_leg_params
      {
        distance: new_params[:distance],
        duration: new_params[:duration],
        sequence_number: new_params[:sequence_number]
      }
    end
end
