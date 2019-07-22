class Api::V1::TripsController < ActionController::API
  def create
    facade = TripFacade.new(trip_params)
    render json: facade.response, status: 201

    # @matt, the below line of code does get run, but I don't think the render
    # returns before it runs
    
    # TripService.new(facade.steps, facade.trip.id)
  end

  private
    def trip_params
      params.permit(:origin, :destination)
    end
end
