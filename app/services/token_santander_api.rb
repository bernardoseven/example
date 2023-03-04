require 'uri'
require 'net/http'
require 'json'

class TokenSantanderApi

  ### Begin agendamepsi api logic
  # sends request of a given historic period
  def self.test_save_historic_data

    therapist_rut = "94684501"
    month = "Noviembre"
    year = "2021"
    result = [{"fecha"=>"02/11/2021", "sucursal"=>"Agustinas", "descripcion"=>"0094684501 Transf. Lorena", "n_documento"=>"001103957", "cargos"=>"", "abonos"=>"3.000.000", "saldo"=>""}]
    #url = URI("https://agendamepsi.cl/api/v1/token_receiver/historic_data")
    url = URI("http://localhost:3001/api/v1/token_receiver/historic_data") 
    
    #url.query = URI.encode_www_form(params)

    https = Net::HTTP.new(url.host, url.port);
    # comment when testing
    #https.use_ssl = true
    request = Net::HTTP::Post.new(url)

    request["Accept"] = "application/json"
    request["Content-Type"] = "application/json"
    #request.format.symbol == :json

    #request.body = "santander[therapist_rut]=#{therapist_rut}&santander[month]=#{month}&santander[year]=#{year}&santander[result]=#{result}".to_json
    request.body = {therapist_rut:"#{therapist_rut}", month:"#{month}", year:"#{year}", result:"#{result}"}.to_json
    response = https.request(request)
    read_body = response.read_body

    return read_body
  end

  # sends request of a given historic period
  # TokenSantanderApi.save_historic_data(therapist_rut,month,year,result)
  def self.save_historic_data(therapist_rut,
                              month,
                              year,
                              result)

  	url = URI("http://agendamepsi.cl/api/v1/token_receiver/historic_data")
    #url = URI("http://localhost:3001/api/v1/token_receiver/historic_data") 
    
    #url.query = URI.encode_www_form(params)

    https = Net::HTTP.new(url.host, url.port);
    # comment when testing and no heroku ssl certificate
    # https.use_ssl = true
    request = Net::HTTP::Post.new(url)

    request["Accept"] = "application/json"
    request["Content-Type"] = "application/json"
    #request.format.symbol == :json

    #request.body = "santander[therapist_rut]=#{therapist_rut}&santander[month]=#{month}&santander[year]=#{year}&santander[result]=#{result}".to_json
    request.body = {therapist_rut:"#{therapist_rut}",month:"#{month}",year:"#{year}",result:"#{result}"}.to_json
    
    response = https.request(request)
    read_body = response.read_body

    return read_body

  end

  def self.test_save_actual_data
    therapist_rut = "94684501"
    result = [{"fecha"=>"02/11/2021", "sucursal"=>"Agustinas", "descripcion"=>"0094684501 Transf. Lorena", "n_documento"=>"001103957", "cargos"=>"", "abonos"=>"3.000.000", "saldo"=>""}]
    #url = URI("https://agendamepsi.cl/api/v1/token_receiver/actual_data")
    url = URI("http://localhost:3001/api/v1/token_receiver/actual_data") 

    https = Net::HTTP.new(url.host, url.port);
    # comment when testing
    #https.use_ssl = true
    request = Net::HTTP::Post.new(url)

    #request.body = "santander[therapist_rut]=#{therapist_rut}&santander[month]=#{month}&santander[year]=#{year}&santander[result]=#{result}"
    request.body = {therapist_rut:"#{therapist_rut}",result:"#{result}"}.to_json

    response = https.request(request)
    read_body = response.read_body

    return read_body
  end

  # sends given perios with actual data
  # Call Example:
  # TokenSantanderApi.save_actual_data(therapist_rut,result)
  def self.save_actual_data(therapist_rut,
                            result)

    url = URI("http://agendamepsi.cl/api/v1/token_receiver/actual_data")
    #url = URI("http://localhost:3001/api/v1/token_receiver/actual_data") 

    https = Net::HTTP.new(url.host, url.port);
    # comment when testing and no heroku ssl certificate
    # https.use_ssl = true
    request = Net::HTTP::Post.new(url)

    request["Accept"] = "application/json"
    request["Content-Type"] = "application/json"

    #request.body = "santander[therapist_rut]=#{therapist_rut}&santander[month]=#{month}&santander[year]=#{year}&santander[result]=#{result}"
    request.body = {therapist_rut:"#{therapist_rut}",result:"#{result}"}.to_json

    response = https.request(request)
    read_body = response.read_body

    return read_body

  end

  ### End agendamepsi api logic

end

