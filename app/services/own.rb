require 'uri'
require 'net/http'
require 'json'

class Own

  # banco santander code
  # server_or_test -> 0 for test 1 for server, integers
  def self.bank_santander_actual(therapist_rut,
                                  password,
                                  server_or_test)
    if server_or_test == 1
      url = URI("http://143.198.167.84/api/v1/santander_methods/actual")
    else
      url = URI("http://localhost:3000/api/v1/santander_methods/actual")
    end

    https = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Post.new(url)

    request.body = "santander[therapist_rut]=#{therapist_rut}&santander[password]=#{password}"

    response = https.request(request)
    read_body = response.read_body
    #parse_json = JSON.parse(read_body)
    return read_body
  end
  
  # server_or_test -> 0 for test 1 for server, integers
  def self.bank_santander_history(therapist_rut,
                                  password,
                                  month,
                                  year,
                                  server_or_test)
    if server_or_test == 1
      url = URI("http://143.198.167.84/api/v1/santander_methods/historic")
    else
      url = URI("http://localhost:3000/api/v1/santander_methods/historic")
    end

    https = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Post.new(url)

    request.body = "santander[therapist_rut]=#{therapist_rut}&santander[password]=#{password}&santander[month]=#{month}&santander[year]=#{year}"

    response = https.request(request)
    read_body = response.read_body
    #parse_json = JSON.parse(read_body)
    return read_body
  end
  # end banco santander code

  # Sii Code
  # server_or_test -> 0 for test 1 for server, integers
  def self.sii_login(therapist_rut, 
                     password,
                     server_or_test)

    if server_or_test == 1
      url = URI("http://143.198.167.84/api/v1/siis_methods/login")
    else
      url = URI("http://localhost:3000/api/v1/siis_methods/login")
    end

    https = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Post.new(url)

    request.body = "sii[therapist_rut]=#{therapist_rut}&sii[password]=#{password}"

    response = https.request(request)
    read_body = response.read_body
    #parse_json = JSON.parse(read_body)
    return read_body 

  end

  def self.create_bhe(therapist_rut, 
                      password,
                      patient_rut,
                      region,
                      comuna,
                      domicilio,
                      name,
                      last_name,
                      glosa_1,
                      valor_1,
                      patient_email,
                      sii_date,
                      server_or_test)

    if server_or_test == 1
      url = URI("http://143.198.167.84/api/v1/siis_methods/createbhe")
    else
      url = URI("http://localhost:3000/api/v1/siis_methods/createbhe")
    end

    https = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Post.new(url)

    request.body = "sii[therapist_rut]=#{therapist_rut}&sii[password]=#{password}&sii[patient_rut]=#{patient_rut}&sii[region]=#{region}&sii[comuna]=#{comuna}&sii[domicilio]=#{domicilio}&sii[name]=#{name}&sii[last_name]=#{last_name}&sii[glosa_1]=#{glosa_1}&sii[valor_1]=#{valor_1}&sii[patient_email]=#{patient_email}&sii[sii_date]=#{sii_date}"

    response = https.request(request)
    read_body = response.read_body
    #parse_json = JSON.parse(read_body)
    return read_body 

  end
  
  # server_or_test -> 0 for test 1 for server, integers
  def self.bhe_list_post(therapist_rut,
                    password,
                    month,
                    year,
                    server_or_test)
    if server_or_test == 1
      url = URI("http://143.198.167.84/api/v1/siis")
    else
      url = URI("http://localhost:3000/api/v1/siis")
    end 

    https = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Post.new(url)

    request.body = "sii[therapist_rut]=#{therapist_rut}&sii[password]=#{password}&sii[month]=#{month}&sii[year]=#{year}&sii[server_or_test]=#{server_or_test}"

    response = https.request(request)
    read_body = response.read_body
    #parse_json = JSON.parse(read_body)
    return read_body

  end
  # End Sii Code

  # example code
  def self.get_s(pick)
    given_url = base_url + '/api/v1/santander_datas/'
    trip = []
    Trip.all.each do |t|
      trip << t.id
    end
    picked_trip = trip.sample
    url = URI("given_url/#{pick}")
    
    #http = Net::HTTP.new(url.host, url.port);
    #https.use_ssl = true

    
    #request["Accept"] = "application/json"
    #request["Content-Type"] = "application/json"
    https = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    read_body = response.read_body
    parse_json = JSON.parse(read_body)
    return parse_json
    #request.body = "trip[name]=#{name}&trip[country]=#{country}&trip[comment]=#{comment}"
    #request.body = "trip[name]=#{name}"
    #response = https.request(request)
    #read_body = response.read_body
    #parse_json = JSON.parse(read_body)
    
    # parse_json["inicio_de_actividades"] cuando rut tiene digito
    # verificador incorrecto devuelve nil
    # cuando rut es correcto devuelve nil la forma de consulta de la primera linea
    #return read_body
    #puts read_body
    #puts parse_json
    #return parse_json
    #http_secure = ""
    #response = Net::HTTP.start(url.hostname, url.port) do |http|
    #  http_secure = http.request(request)
    #end
    #final_response = http_secure
    #puts final_response
    #return final_response
  end
  # server_or_test -> 0 for test 1 for server, integers
  def self.bhe_list_get(therapist_rut,
                    password,
                    month,
                    year,
                    server_or_test)
    if server_or_test == 1
      url = URI("http://143.198.167.84/api/v1/siis")
    else
      url = URI("http://localhost:3000/api/v1/siis")
    end 

    https = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    read_body = response.read_body
    parse_json = JSON.parse(read_body)
    return parse_json

  end

  # example code
  def self.get_s(pick)
    given_url = base_url + '/api/v1/santander_datas/'
    trip = []
    Trip.all.each do |t|
      trip << t.id
    end
    picked_trip = trip.sample
    url = URI("given_url/#{pick}")
    
    #http = Net::HTTP.new(url.host, url.port);
    #https.use_ssl = true

    
    #request["Accept"] = "application/json"
    #request["Content-Type"] = "application/json"
    https = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    read_body = response.read_body
    parse_json = JSON.parse(read_body)
    return parse_json
    #request.body = "trip[name]=#{name}&trip[country]=#{country}&trip[comment]=#{comment}"
    #request.body = "trip[name]=#{name}"
    #response = https.request(request)
    #read_body = response.read_body
    #parse_json = JSON.parse(read_body)
    
    # parse_json["inicio_de_actividades"] cuando rut tiene digito
    # verificador incorrecto devuelve nil
    # cuando rut es correcto devuelve nil la forma de consulta de la primera linea
    #return read_body
    #puts read_body
    #puts parse_json
    #return parse_json
    #http_secure = ""
    #response = Net::HTTP.start(url.hostname, url.port) do |http|
    #  http_secure = http.request(request)
    #end
    #final_response = http_secure
    #puts final_response
    #return final_response
  end

  # server_or_test -> 0 for test 1 for server, integers
  def self.delete_bhe(therapist_rut, 
                     password,
                     bhe_number,
                     server_or_test)

    if server_or_test == 1
      url = URI("http://143.198.167.84/api/v1/siis_methods/delete-bhe")
    else
      url = URI("http://localhost:3000/api/v1/siis_methods/delete-bhe")
    end

    https = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Post.new(url)

    request.body = "sii[therapist_rut]=#{therapist_rut}&sii[password]=#{password}&sii[bhe_number]=#{bhe_number}"

    response = https.request(request)
    read_body = response.read_body
    #parse_json = JSON.parse(read_body)
    return read_body 

  end

  def self.test_create_bhe(server_or_test)

    therapist_rut ="164828611"
    password ="FhG5FhG1"
    patient_rut ="94684501"
    region ="REGION METROPOLITANA DE SANTIAGO"
    comuna ="LAS CONDES"
    domicilio ="los militares 801"
    name ="Jane"
    last_name ="Doe"
    glosa_1 ="seco total"
    valor_1 = 100
    patient_email ="darvilleconsulta@gmail.com"
    sii_date ="2021-08-20 00:00:00 UTC"

    if server_or_test == 1
      url = URI("http://143.198.167.84/api/v1/siis_methods/createbhe")
    else
      url = URI("http://localhost:3000/api/v1/siis_methods/createbhe")
    end

    https = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Post.new(url)

    request.body = "sii[therapist_rut]=#{therapist_rut}&sii[password]=#{password}&sii[patient_rut]=#{patient_rut}&sii[region]=#{region}&sii[comuna]=#{comuna}&sii[domicilio]=#{domicilio}&sii[name]=#{name}&sii[last_name]=#{last_name}&sii[glosa_1]=#{glosa_1}&sii[valor_1]=#{valor_1}&sii[patient_email]=#{patient_email}&sii[sii_date]=#{sii_date}"
    
    begin

      response = https.request(request)
      read_body = response.read_body
      return read_body
      
    rescue

      return false

    ensure

      # something
    
    end

  end

end