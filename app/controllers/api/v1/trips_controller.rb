class Api::V1::TripsController < ActionController::API
  def create
    facade = TripFacade.new(trip_params)
    render json: facade.response, status: 201

    # @matt, the below line of code does get run, but I don't think the render
    # returns before it runs
    
    # TripService.new(facade.steps, facade.trip.id)
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

  private
    def trip_params
      params.permit(:origin, :destination)
    end

    def trip_token_params
      params.permit(:token)
    end
end
