class Api::V1::SiisController < ActionController::API
  
  def index 
    render json: { result: 'hola!'}.to_json, status: :ok
  end

  def get_post
  end

  def sii_login
    result = SiiBot.login(params["sii"]["therapist_rut"], 
                          params["sii"]["password"])

    if result != nil
      render json: result, status: :ok
    else
      render json: nil, status: :ok
    end 

  end

  # total bhe created in a given period
  def create
  	#my_params = params["sii"]["therapist_rut"]
  	result = SiiBot.total_bhe(params["sii"]["therapist_rut"],
		                      params["sii"]["password"],
		                      params["sii"]["month"],
		                      params["sii"]["year"])
    if result != nil
      render json: result, status: :ok
    else
      return "No!!!"
    end
    
  end

  def bhes_received
    result = SiiBot.total_bhe_received(params["sii"]["therapist_rut"],
                          params["sii"]["password"],
                          params["sii"]["month"],
                          params["sii"]["year"])
    if result != nil
      render json: result, status: :ok
    else
      return "No!!!"
    end
  end

  def bhe_create
    result = SiiBot.user_retains(params["sii"]["therapist_rut"], 
                                params["sii"]["password"],
                                params["sii"]["patient_rut"],
                                params["sii"]["region"],
                                params["sii"]["comuna"],
                                params["sii"]["domicilio"],
                                params["sii"]["name"],
                                params["sii"]["last_name"],
                                params["sii"]["glosa_1"],
                                params["sii"]["valor_1"],
                                params["sii"]["patient_email"],
                                params["sii"]["sii_date"])
    if result != nil && result != false
      render json: result, status: :ok
    else
      return "No fue posible crear la boleta"
    end
  end

  def bhe_create_receptor
    result = SiiBot.user_dont_retains(params["sii"]["therapist_rut"], 
                                params["sii"]["password"],
                                params["sii"]["patient_rut"],
                                params["sii"]["region"],
                                params["sii"]["comuna"],
                                params["sii"]["domicilio"],
                                params["sii"]["name"],
                                params["sii"]["last_name"],
                                params["sii"]["glosa_1"],
                                params["sii"]["valor_1"],
                                params["sii"]["patient_email"],
                                params["sii"]["sii_date"])
    if result != nil && result != false
      render json: result, status: :ok
    else
      return "No fue posible crear la boleta"
    end
  end

  def delete_bhe
    result = SiiBot.delete_bhe(params["sii"]["therapist_rut"], 
                               params["sii"]["password"],
                               params["sii"]["bhe_number"].to_i
                              )
    if result != false && result != nil
      render json: result, status: :ok
    else
      render json: {error:"no fue posible eliminar la boleta"}, status: :ok
    end
    
  end

end


