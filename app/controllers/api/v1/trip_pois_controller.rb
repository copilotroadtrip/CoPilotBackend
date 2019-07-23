class Api::V1::TripPoisController < ActionController::API
  def create
    trip = Trip.find_by(token: trip_token[:token])

    if !trip
      render json: { message: 'Invalid Token'}, status: 404
    else
      trip.trip_pois.create(new_trip_poi_params)

      render json: { message: 'Success' }, status: 201
    end
  end

  private
    def trip_token
      params.permit(:token)
    end

    def new_trip_poi_params
      params.require(:trip_poi).permit(
        :poi_id,
        :name,
        :state,
        :population,
        :lat,
        :lng,
        :sequence_number,
        :time_to_poi
      )
    end
end
