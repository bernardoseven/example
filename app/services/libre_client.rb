require 'uri'
require 'net/http'
require 'json'

class LibreClient

  # Situación Tributaria sin SII password, only rut!!
  def tax_situation(rut)
    # rut jose 14122147-7
    # rut mio 16482861-1
    # rut mama 6421737-2
    # rut pollo 9468450-1
    # rut papa 7778301-6
    # rut cooper 4574435-3
    # rut no valido 4574435-4 
    given_rut = rut
    libre_dte_rut_format = RutValidation.new.correct_rut_format(given_rut)
    #given_rut = rut
    url = URI("https://api.libredte.cl/api/v1/sii/contribuyentes/situacion_tributaria/tercero/#{libre_dte_rut_format}?formato=json")
    api_key = access_token
 
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Accept"] = "application/json"
    request["Authorization"] = "Bearer #{api_key}"
    response = https.request(request)
    read_body = response.read_body
    parse_json = JSON.parse(read_body)
    
    # parse_json["inicio_de_actividades"] cuando rut tiene digito
    # verificador incorrecto devuelve nil
    # cuando rut es correcto devuelve nil la forma de consulta de la primera linea
    #return read_body
    puts read_body
    puts parse_json
    return parse_json
    #testing json postgresql
    #Json.create(json_value: parse_json)
  end

  # WORKS JUST FINE!!!
  def create_bhe(given_rut, given_password)
    libre_dte_rut_format = RutValidation.new.correct_rut_format(given_rut)
    t = Time.now
    date = t.year.to_s+"-"+t.month.to_s+"-"+t.day.to_s
    rut_emisor = libre_dte_rut_format
    user_sii_password = given_password
    date_bhe = date
    # emisor paga impuesto 2, receptor paga impuesto 1
    retention_type = 2
    rut_receptor = "76268374-1"
    address = "Los Militares 5620"
    comuna = "Las Condes"
    glosa1 = "Consulta Servicios Profesionales"
    amount1 = 100

    url = URI("https://api.libredte.cl/api/v1/sii/bhe/emitidas/emitir")
    api_key = access_token
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Accept"] = "application/json"
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{api_key}"
    #
    # just works fine
    request.body = "{\n    \"auth\": {\n        \"pass\": {\n            \"rut\": \"#{rut_emisor}\",\n            \"clave\": \"#{user_sii_password}\"\n        }\n    },\n    \"boleta\": {\n        \"Encabezado\": {\n            \"IdDoc\": {\n                \"FchEmis\": \"#{date_bhe}\",\n                \"TipoRetencion\": #{retention_type}\n            },\n            \"Emisor\": {\n                \"RUTEmisor\": \"#{rut_emisor}\"\n            },\n            \"Receptor\": {\n                \"RUTRecep\": \"#{rut_receptor}\",\n                \"RznSocRecep\": \"Receptor generico\",\n                \"DirRecep\": \"#{address}\",\n                \"CmnaRecep\": \"#{comuna}\"\n            }\n        },\n        \"Detalle\": [\n            {\n                \"NmbItem\": \"#{glosa1}\",\n                \"MontoItem\": #{amount1}\n }    ]\n    }\n}"

    response = https.request(request)
    #puts response.read_body
    read_body = response.read_body
    parse_json = JSON.parse(read_body)
    puts parse_json
    return parse_json
  end

  # WORKS JUST FINE!!!
  def create_bhe_sii(given_rut, given_password, given_date,
    given_retention_type, given_rut_receptor, given_address,
    given_comuna, given_glosa1, given_amount1)
    libre_dte_given_rut = RutValidation.new.correct_rut_format(given_rut)
    libre_dte_given_rut_receptor = RutValidation.new.correct_rut_format(given_rut_receptor)
    t = given_date.to_time
    date = t.year.to_s+"-"+t.month.to_s+"-"+t.day.to_s
    rut_emisor = libre_dte_given_rut
    rut_receptor = libre_dte_given_rut_receptor
    user_sii_password = given_password
    date_bhe = date
    # emisor paga impuesto 2, receptor paga impuesto 1
    retention_type = given_retention_type
    address = given_address
    comuna = given_comuna
    glosa1 = given_glosa1
    amount1 = given_amount1

    url = URI("https://api.libredte.cl/api/v1/sii/bhe/emitidas/emitir")
    api_key = access_token
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Accept"] = "application/json"
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{api_key}"
    #
    # just works fine
    request.body = "{\n    \"auth\": {\n        \"pass\": {\n            \"rut\": \"#{rut_emisor}\",\n            \"clave\": \"#{user_sii_password}\"\n        }\n    },\n    \"boleta\": {\n        \"Encabezado\": {\n            \"IdDoc\": {\n                \"FchEmis\": \"#{date_bhe}\",\n                \"TipoRetencion\": #{retention_type}\n            },\n            \"Emisor\": {\n                \"RUTEmisor\": \"#{rut_emisor}\"\n            },\n            \"Receptor\": {\n                \"RUTRecep\": \"#{rut_receptor}\",\n                \"RznSocRecep\": \"Receptor generico\",\n                \"DirRecep\": \"#{address}\",\n                \"CmnaRecep\": \"#{comuna}\"\n            }\n        },\n        \"Detalle\": [\n            {\n                \"NmbItem\": \"#{glosa1}\",\n                \"MontoItem\": #{amount1}\n }    ]\n    }\n}"

    response = https.request(request)
    #puts response.read_body
    read_body = response.read_body
    parse_json = JSON.parse(read_body)
    return parse_json
  end

  def send_bhe(rut_emisor, bhe_bar_code, user_sii_password, email_receptor)
    # 0946845001540498398B
    libre_dte_rut_format = RutValidation.new.correct_rut_format(rut_emisor)
    rut_emisor = libre_dte_rut_format
    bhe_bar_code = bhe_bar_code
    user_sii_password = user_sii_password
    email_receptor = email_receptor
    url = URI("https://api.libredte.cl/api/v1/sii/bhe/emitidas/email/#{bhe_bar_code}")
    api_key = access_token
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Accept"] = "application/json"
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{api_key}"
    request.body = "{\n\t\"auth\": {\n\t\t\"pass\": {\n        \t\"rut\": \"#{rut_emisor}\",\n        \t\"clave\": \"#{user_sii_password}\"\n\t\t}\n    },\n    \"destinatario\": {\n    \t\"email\": \"#{email_receptor}\"\n    }\n}\n"

    response = https.request(request)
    #puts response.read_body
    read_body = response.read_body
    parse_json = JSON.parse(read_body)
    puts parse_json
    return parse_json
  end

  # Works just fine
  def delete_bhe(given_rut, given_password, given_folio)
    libre_dte_rut_format = RutValidation.new.correct_rut_format(given_rut)
    rut_emisor = libre_dte_rut_format
    user_sii_password = given_password
    folio_bhe = given_folio
    delete_bhe_cause = 3
    url = URI("https://api.libredte.cl/api/v1/sii/bhe/emitidas/anular/#{rut_emisor}/#{folio_bhe}?formato=json&causa=#{delete_bhe_cause}")
    #api_key = ApiDev.new.access_token
    api_key = access_token
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Accept"] = "application/json"
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{api_key}"
    request.body = "{\n\t\"auth\": {\n\t\t\"pass\": {\n        \t\"rut\": \"#{rut_emisor}\",\n        \t\"clave\": \"#{user_sii_password}\"\n\t\t}\n    }\n}\n"

    response = https.request(request)
    #puts response.read_body
    read_body = response.read_body
    parse_json = JSON.parse(read_body)
    return parse_json
  end

  # periodo format: 201908 
  def list_bhe(given_rut, given_password, given_periodo)
    libre_dte_rut_format = RutValidation.new.correct_rut_format(given_rut)
    rut_emisor = libre_dte_rut_format
    user_sii_password = given_password
    periodo = given_periodo
    url = URI("https://api.libredte.cl/api/v1/sii/bhe/emitidas/documentos/#{rut_emisor}/#{periodo}?formato=json")
    
    api_key = access_token
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Accept"] = "application/json"
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{api_key}"
    #request.body = "{\n\t\"auth\": {\n\t\t\"pass\": {\n        \t\"rut\": \"#{rut_emisor}\",\n        \t\"clave\": \"#{user_sii_password}\"\n\t\t}\n    }\n}\n"
    request.body = "{\n\t\"auth\": {\n\t\t\"pass\": {\n        \t\"rut\": \"#{rut_emisor}\",\n        \t\"clave\": \"#{user_sii_password}\"\n\t\t}\n    }\n}\n"

    response = https.request(request)
    read_body = response.read_body
    parse_json = JSON.parse(read_body)
    puts parse_json
    return read_body
  end

  # perido: 201911 not ready yet
  # Responds with the summatory, not the details, example
  # if there are 8 documents, puts the total value of the 8 documents
  def sales_summary(given_rut, given_password, given_periodo)
    libre_dte_rut_format = RutValidation.new.correct_rut_format(given_rut)
    rut_emisor = libre_dte_rut_format
    user_sii_password = given_password
    periodo = given_periodo
    url = URI("https://api.libredte.cl/api/v1/sii/rcv/ventas/resumen/#{rut_emisor}/#{periodo}?formato=json&certificacion=0")

    api_key = access_token
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Accept"] = "application/json"
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{api_key}"
    request.body = "{\n\t\"auth\": {\n\t\t\"pass\": {\n        \t\"rut\": \"#{rut_emisor}\",\n        \t\"clave\": \"#{user_sii_password}\"\n\t\t}\n    }\n}\n"

    response = https.request(request)
    read_body = response.read_body
    parse_json = JSON.parse(read_body)
    puts parse_json
    return parse_json
  end

  # perido: 201911 not ready yet
  # Responds with the the details of exactly one document..
  def sales_details(given_rut, given_password, given_periodo)
    libre_dte_rut_format = RutValidation.new.correct_rut_format(given_rut)
    rut_emisor = libre_dte_rut_format
    user_sii_password = given_password
    periodo = given_periodo
    url = URI("https://api.libredte.cl/api/v1/sii/rcv/ventas/detalle/#{rut_emisor}/#{periodo}/33?formato=json&certificacion=rcv")
              #'https://api.libredte.cl/api/v1/sii/rcv/ventas/detalle/76192083-9/201911/33?formato=json&certificacion=0&tipo=rcv' 

    api_key = access_token
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Accept"] = "application/json"
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{api_key}"
    request.body = "{\n\t\"auth\": {\n\t\t\"pass\": {\n        \t\"rut\": \"#{rut_emisor}\",\n        \t\"clave\": \"#{user_sii_password}\"\n\t\t}\n    }\n}\n"

    response = https.request(request)
    read_body = response.read_body
    parse_json = JSON.parse(read_body)
    puts parse_json
    return parse_json
  end

  def libre_sales_summary
    url = URI("https://api.libredte.cl/api/v1/sii/rcv/ventas/resumen/76268374-1/202106?formato=json&certificacion=0")

    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Accept"] = "application/json"
    request["Content-Type"] = "application/json"
    request.body = "{\n\t\"auth\": {\n\t\t\"pass\": {\n        \t\"rut\": \"76268374-1\",\n        \t\"clave\": \"FhG5FhG1\"\n\t\t}\n    }\n}\n"

    response = https.request(request)
    read_body = response.read_body
    parse_json = JSON.parse(read_body)
    puts parse_json
    return parse_json
  end


  private
  
    def access_token
      new_api_key = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMjc4MWVjNTE1OTA2MWE2NjI0OWE4NDM1Yzg2ODcyZWU0NjIyMDQwODdmY2MxODA1YjQzNGEyMjg5MDgyYzlkN2NlYzBiYmNkYTQ2ZjJhNjkiLCJpYXQiOjE2MjU3NzM2NzIsIm5iZiI6MTYyNTc3MzY3MiwiZXhwIjoxNjU3MzA5NjcyLCJzdWIiOiI3MDUiLCJzY29wZXMiOltdfQ.U-N3hRxIs-974n2L9TIvHm_YsGJ7A6_00K7xOX2n6IPwl_HgqknMtEiYPrnc8M9xenBFNOONzIHwGphD-q7FLnHYEUiRdKjRxrriYEJyoZhnrIYS4gKiukEiKA77SLQtuonG7N3JoIuQny62DhW8f4GHQiEaXXcgB71ZjYAu35PYehUjScXvawD2C1JnRxKnCL8tQtcO-HggLDnrKOLcew50ZYw33DCieM7UMfu22j0nxwnRIiwMbNqAK1W2RdA1QQM6TKHNwdCrBQV3xAUmyRC5025fZS36WAF00Sg6NO1BAgDu_81vWKhKQ5VEKdOCLeDN-IE52RpZrKsmmnHzWmlQYGfZa9lC87PFcO9tSrC3zzUKO338wB9WZSEJC6567-5gF-VgsqoKv4tlZapEdyYePtiI-qqCWBJFluat3imVWBSrmQClLr3jtBTVCtPyHj7cowtJhnToxTF_6fWnE18sTSeSRMV-Ros0PJc2yJhP3rxxvqJyviSSLlymMXk86FVX727e_4Aw_9afkFiyl5JA9rY-VbPEvPAtnKF8_MuwO-kFedE27dbm6KJjI_jZ9LkqjJc6iYyxgHYLgdtvt-dhJDGR_gFICmth8loLI6jBteanhRt9W40OyYbFcO884IPA0QnrY3IcCZSrpOqF8zJbhVcvc0Yk5NimB2y-AzE"
      return new_api_key
    end  

end

