class Api::V1::TestTokensController < ActionController::API

  # Santander Logic
  
  def historic_data
    
    result = TokenSantanderBot.cartola_historica(params["santander"]["therapist_rut"],
                                                 params["santander"]["password"],
                                                 params["santander"]["month"],
                                                 params["santander"]["year"])

=begin
    if result != nil
      render json: result, status: :ok
    else
      render json: nil, status: :ok
    end
=end 

  end

  def actual_data

    result = TokenSantanderBot.cartola_actual(params["santander"]["therapist_rut"],
                                              params["santander"]["password"])
  
  end 

  # End Santander Logic



  # SII Logic

  def sii_login
    
    result = TestTokenSiiBot.login(params["sii"]["therapist_rut"],
                                   params["sii"]["password"])

    if result != nil
      if result == true
        render json: result, status: :ok
      else
        render json: result, status: :ok
      end
    else
      render json: nil, status: :nil
    end

  end

  def bhe_create

    #random_token = SimpleToken.call

    #render json: random_token, status: :ok

    result = TestTokenSiiBot.user_retains(params["sii"]["therapist_rut"], 
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
                                params["sii"]["sii_date"],
                                params["sii"]["appointment_id"],
                                params["sii"]["emisor_receptor"].to_i)

    if result != nil
      if result == true
        render json: result, status: :ok
      else
        render json: result, status: :ok
      end
    else
      render json: nil, status: :nil
    end


  end

  def created_bhes

    result = TestTokenSiiBot.total_bhe(params["sii"]["therapist_rut"],
                          params["sii"]["password"],
                          params["sii"]["month"],
                          params["sii"]["year"])

    if result != nil
      if result == true
        render json: result, status: :ok
      else
        render json: result, status: :ok
      end
    else
      render json: nil, status: :nil
    end

  end

  def delete_bhe
    
    result = TestTokenSiiBot.delete_bhe(params["sii"]["therapist_rut"], 
                               params["sii"]["password"],
                               params["sii"]["bhe_number"].to_i,
                               params["sii"]["reason"].to_i
                              )
    if result != false && result != nil
      render json: result, status: :ok
    else
      render json: {error:"no fue posible eliminar la boleta"}, status: :ok
    end

  end

  # End SII Logic

  ### Resilient code
  def post_created_bhes
  end
  ### End resilient code

end


