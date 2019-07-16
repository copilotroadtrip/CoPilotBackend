class Api::V1::TripsController < ActionController::API
  def create
    render json: TripFacade.new(trip_params).response, status: 201
  end

  private
    def trip_params
      params.permit(:origin, :destination)
    end
end
