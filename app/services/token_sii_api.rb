require 'uri'
require 'net/http'
require 'json'

class TokenSiiApi
  
  ### Begin agendamepsi api logic

  # Sends request with created bhe info to agendamepsi
  def self.save_bhe_data_logic(
	  					folio,
	  					bar_code,
	  					rut_emisor,
	  					result,
	  					appointment_id)

  	url = URI("http://agendamepsi.cl/api/v1/token_receiver/appointment_invoice_api")
    #url = URI("http://localhost:3001/api/v1/token_receiver/appointment_invoice_api") 
   

    https = Net::HTTP.new(url.host, url.port);
    # if testing use_ssl must be commented
    # if heroku lacks ssl it must be commented as well
    #https.use_ssl = true
    request = Net::HTTP::Post.new(url)

    request.body = "sii[folio]=#{folio}&sii[bar_code]=#{bar_code}&sii[result]=#{result}&sii[appointment_id]=#{appointment_id}&sii[rut_emisor]=#{rut_emisor}"

    response = https.request(request)
    read_body = response.read_body

    return read_body

  end

  # Sends request with a bhe list of a given period
  # Call Example:
  # TokenSiiApi.period_bhe_list("94684501","freudlacan","11","2021")
  def self.period_bhe_list(therapist_rut,
                           month,
                           year,
                           parse_json)

    #url = URI("http://agendamepsi.cl/api/v1/token_receiver/therapist_bhe_list")
    url = URI("http://localhost:3001/api/v1/token_receiver/therapist_bhe_list") 

    https = Net::HTTP.new(url.host, url.port);
    # if testing use_ssl must be commented
    # if heroku lacks ssl it must be commented as well
    #https.use_ssl = true
    request = Net::HTTP::Post.new(url)

    request.body = "sii[therapist_rut]=#{therapist_rut}&sii[month]=#{month}&sii[year]=#{year}&sii[parse_json]=#{parse_json}"

    response = https.request(request)
    read_body = response.read_body

    return read_body

  end

  def self.delete_bhe_data_logic()
    
  end

  ### End agendamepsi api logic

end

