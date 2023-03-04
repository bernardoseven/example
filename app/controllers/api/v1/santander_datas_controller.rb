class Api::V1::SantanderDatasController < ActionController::API
  #skip_before_action :verify_authenticity_token

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
      @trip = { id: @trip.id, name: @trip.name, country: @trip.country, comment: @trip.comment }
      render json: { result: @trip }.to_json, status: :ok 
      puts @trip
    else
      render json: { error: { message: "not found"} }.to_json, status: :ok
    end
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      #render json: { result: @trip }.to_json, status: :ok
      redirect_to "/api/v1/santander_datas/5"
    else
      render json: { error: "trip could not be created" }.to_json, status: 400
    end
  end

  # custom methods
  def actual_data
    result = SantanderBot.cartola_actual(params["santander"]["therapist_rut"],
                                         params["santander"]["password"])

    if result != nil
      render json: result, status: :ok
    else
      render json: nil, status: :ok
    end
  end

  def historic_data
    result = SantanderBot.cartola_historica(params["santander"]["therapist_rut"],
                                            params["santander"]["password"],
                                            params["santander"]["month"],
                                            params["santander"]["year"])

    if result != nil
      render json: result, status: :ok
    else
      render json: nil, status: :ok
    end
  end
  # end custom methods

  
  private
    
    def trip_params
      params.require(:trip).permit(
        :name,
        :country,
        :comment)
    end

end