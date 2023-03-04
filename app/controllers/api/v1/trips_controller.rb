class Api::V1::TripsController < ActionController::API
  
  def index
    @trips = Trip.all
    @trips = @trips.map do |trip|
      { id: trip.id, name: trip.name }
    end
    
    render json: { results: @trips }.to_json, status: :ok
  end

  def show
    given_id = params[:id]
    @trip = Trip.find_by(id: given_id)
    #@trip = Trip.find(params[:id])
    if @trip.present?
      @trip = { id: @trip.id, name: @trip.name }
      render json: { result: @trip }.to_json, status: :ok
      #return json: { result: @trip }.to_json
    else
      render json: { error: { message: "not found"} }.to_json, status: :ok
    end
  end

end