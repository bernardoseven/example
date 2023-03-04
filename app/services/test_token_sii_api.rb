require 'uri'
require 'net/http'
require 'json'

class TestTokenSiiApi

  # TestTokenSiiApi.test_login(0)
  def self.test_login(server_or_test)
    
    therapist_rut ="164828611"
    password ="FhG5FhG1"

    if server_or_test == 1
      url = URI("http://159.223.98.227/api/v1/tokens_sii/sii_login")
    else
      url = URI("http://localhost:3000/api/v1/test_tokens_sii/sii_login")
    end

    https = Net::HTTP.new(url.host, url.port);
    
    request = Net::HTTP::Post.new(url)

    request.body = "sii[therapist_rut]=#{therapist_rut}&sii[password]=#{password}"
    
    response = https.request(request)

    read_body = response.read_body

    return read_body

  end

  # TestTokenSiiApi.total_bhe("2021","01",0)
  def self.total_bhe(year, month, server_or_test)
    
    therapist_rut ="94684501"
    password ="freudlacan"
    #month ="01"
    #year ="2022"

    if server_or_test == 1
      url = URI("http://159.223.98.227/api/v1/test_tokens_sii/created_bhes")
    else
      url = URI("http://localhost:3000/api/v1/test_tokens_sii/created_bhes")
    end

    https = Net::HTTP.new(url.host, url.port);
    
    request = Net::HTTP::Post.new(url)

    request.body = "sii[therapist_rut]=#{therapist_rut}&sii[password]=#{password}&sii[month]=#{month}&sii[year]=#{year}"
    
    response = https.request(request)

    read_body = response.read_body

    return read_body

  end

  # TestTokenSiiApi.test_create_bhe_receptor(0,1)
  def self.test_create_bhe_receptor(server_or_test, emisor_receptor)

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
    sii_date ="2022-03-28 00:00:00 UTC"

    if server_or_test == 1
      url = URI("http://143.198.167.84/api/v1/test_tokens_sii/bhe_create")
    else
      url = URI("http://localhost:3000/api/v1/test_tokens_sii/bhe_create")
    end

    https = Net::HTTP.new(url.host, url.port);
    
    request = Net::HTTP::Post.new(url)

    request.body = "sii[therapist_rut]=#{therapist_rut}&sii[password]=#{password}&sii[patient_rut]=#{patient_rut}&sii[region]=#{region}&sii[comuna]=#{comuna}&sii[domicilio]=#{domicilio}&sii[name]=#{name}&sii[last_name]=#{last_name}&sii[glosa_1]=#{glosa_1}&sii[valor_1]=#{valor_1}&sii[patient_email]=#{patient_email}&sii[sii_date]=#{sii_date}&sii[emisor_receptor]=#{emisor_receptor}"
    
    response = https.request(request)

    read_body = response.read_body

    return read_body

  end

  # TestTokenSiiApi.delete_bhe(1070, 3)
  def self.delete_bhe(bhe_number, reason)
    therapist_rut = "164828611"
    password = "FhG5FhG1"
    #url = URI("http://143.198.167.84/api/v1/siis_methods/delete-bhe")
    url = URI("http://localhost:3000/api/v1/test_tokens_sii/delete_bhe")
    #url = URI("http://localhost:3000/api/v1/siis_methods/delete-bhe")

    https = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Post.new(url)

    request.body = "sii[therapist_rut]=#{therapist_rut}&sii[password]=#{password}&sii[bhe_number]=#{bhe_number}&sii[reason]=#{reason}"

    response = https.request(request)
    read_body = response.read_body
    #parse_json = JSON.parse(read_body)
    return read_body
  end

end