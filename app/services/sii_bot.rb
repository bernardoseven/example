require 'kimurai'
require 'mechanize'
require 'capybara'
require 'nokogiri'
require 'open-uri'
require 'watir'
require 'json'

class SiiBot

  # modified
  def self.login(therapist_rut, 
                 password)
    if Rails.env.production?
      args = ['--no-sandbox',
              '--disable-extensions',
              '--ignore-certificate-errors',
              '--headless',
              '--start-maximized']
              # remember to add --headless
      browser = Watir::Browser.new :firefox, options: {args: args}
      #browser = Watir::Browser.new :chrome, options: {args: args}
    else
      args = ['--no-sandbox',
              '--disable-extensions',
              '--ignore-certificate-errors',
              '--headless',
              '--start-maximized']
              # remember to add --headless
      browser = Watir::Browser.new :firefox, options: {args: args}
      #browser = Watir::Browser.new :chrome, options: {args: args}
    end 

    now = Time.now

    condition = true

    check_time = Time.now
    
    transcurred_time = (check_time - now).to_i

    while transcurred_time <= 27 && condition == true do 
      
      browser.goto 'https://zeusr.sii.cl//AUT2000/InicioAutenticacion/IngresoRutClave.html?https://misiir.sii.cl/cgi_misii/siihome.cgi'

      rut_box = browser.text_field(id:'rutcntr').present?
      pass_box = browser.text_field(id:'clave').present?
      ingresar_button = browser.button(id:'bt_ingresar').present?
      
      if rut_box == true && pass_box == true && ingresar_button == true
      
        condition = false
      
        browser.text_field(id:'rutcntr').set "#{therapist_rut}"
        browser.text_field(id:'clave').set "#{password}"
        browser.button(id:'bt_ingresar').click

        now = Time.now
        
        check_time = Time.now
        
        transcurred_time = (check_time - now).to_i
       
        while transcurred_time <= 15 do 
          
          authenticated = browser.element(id:'conAutenticacion').locate.present?
          
          if authenticated == true
          
            # i could pass the browser object here to another 
            # method, an manipulate it as I want
            browser.close
            return true
          
          else

            check_time = Time.now
            transcurred_time = (check_time - now).to_i

            if transcurred_time >= 13
              
              browser.close
              return false

            end
          
          end

        end 
      
      else

        puts "elements not founded yet"
        check_time = Time.now
        transcurred_time = (check_time - now).to_i

        if transcurred_time > 25

          browser.close
          puts "elements not founded"
          return false

        end

      end

    end

  end

  def self.reuse_login(therapist_rut,
                       password)

    if Rails.env.production?
      args = ['--no-sandbox',
              '--disable-extensions',
              '--ignore-certificate-errors',
              '--headless',
              '--start-maximized']
              # remember to add --headless
      browser = Watir::Browser.new :firefox, options: {args: args}
      #browser = Watir::Browser.new :chrome, options: {args: args}
    else
      args = ['--no-sandbox',
              '--disable-extensions',
              '--ignore-certificate-errors',
              '--headless',
              '--start-maximized']
              # remember to add --headless
      browser = Watir::Browser.new :firefox, options: {args: args}
      #browser = Watir::Browser.new :chome, options: {args: args}
    end 

    now = Time.now

    condition = true

    check_time = Time.now
    
    transcurred_time = (check_time - now).to_i

    while transcurred_time <= 27 && condition == true do 
      
      browser.goto 'https://zeusr.sii.cl//AUT2000/InicioAutenticacion/IngresoRutClave.html?https://misiir.sii.cl/cgi_misii/siihome.cgi'

      rut_box = browser.text_field(id:'rutcntr').present?
      pass_box = browser.text_field(id:'clave').present?
      ingresar_button = browser.button(id:'bt_ingresar').present?
      
      if rut_box == true && pass_box == true && ingresar_button == true
      
        condition = false
      
        browser.text_field(id:'rutcntr').set "#{therapist_rut}"
        browser.text_field(id:'clave').set "#{password}"
        browser.button(id:'bt_ingresar').click

        now = Time.now
        
        check_time = Time.now
        
        transcurred_time = (check_time - now).to_i
       
        while transcurred_time <= 15 do 

          if browser.url == 'https://misiir.sii.cl/cgi_misii/siihome.cgi'
          
            # i could pass the browser object here to another 
            # method, an manipulate it as I want

            return browser
          
          else

            check_time = Time.now
            transcurred_time = (check_time - now).to_i

            if transcurred_time >= 13
              
              browser.close
              return false

            end
          
          end

        end 
      
      else

        puts "elements not founded yet"
        check_time = Time.now
        transcurred_time = (check_time - now).to_i

        if transcurred_time > 25

          browser.close
          puts "elements not founded"
          return false

        end

      end

    end

  end

  # needs a little work to retrieve de amounts
  # it would be better to catch that
  def self.user_dont_retains(therapist_rut, 
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
                            sii_date)

    begin

      date = FormatScrapped.bhe_date(sii_date)

      browser = reuse_login(therapist_rut,
                           password)
      
      browser = check_browser_status(browser)

      patient_rut_without_dv = patient_rut.split("")
      dv = patient_rut_without_dv.last
      patient_rut_without_dv.pop
      final_patient_rut = patient_rut_without_dv.join

      # url: https://loa.sii.cl/cgi_IMT/TMBECN_ValidaTimbrajeContrib.cgi?modo=1&dummy=1461943054813
      # goes to page where is needed to decide to choose tax retains or not
      url = "https://loa.sii.cl/cgi_IMT/TMBECN_ValidaTimbrajeContrib.cgi?modo=1&dummy=1461943054813"
      
      browser.goto url

      browser = check_url(browser, url)

      radio = browser.radio(value:'RETRECEPTOR')
            
      radio.select

      browser.button(id:'cmdContinuar').click

      # url: https://loa.sii.cl/cgi_IMT/TMBECN_PresentaDatosBoleta.cgi
      # check page where a user needs to send his personal info
      url = "https://loa.sii.cl/cgi_IMT/TMBECN_PresentaDatosBoleta.cgi"

      browser = check_url(browser, url)

      # selects day
      browser.select_list(name:'cbo_dia_boleta').select("#{date[0]}")
      # selects month
      browser.select_list(name:'cbo_mes_boleta').select("#{date[1]}")
      # selects year
      browser.select_list(name:'cbo_anio_boleta').select("#{date[2]}")
      # rut with no dv (incomplete)
      browser.text_field(name:'txt_rut_destinatario').set "#{final_patient_rut}"
      browser.text_field(name:'txt_dv_destinatario').set "#{dv}"
      browser.text_field(name:'txt_domicilio_destinatario').set "#{domicilio}"
      
      browser.select_list(name:'cod_region').click
      browser.option(text:"#{region}").click

      browser.select_list(name:'cbo_comuna').click
      browser.option(text:"#{comuna}").click
      #comuna.select(text: 'PROVIDENCIA')
      #sleep 2

      browser.text_field(id:'desc_prestacion_1').set "#{glosa_1}"
      browser.text_field(id:'valor_prestacion_1').set "#{valor_1}"
      # if all goes fine it should change page
      browser.button(name:'cmdAceptar').click


      # url: https://loa.sii.cl/cgi_IMT/TMBECN_ConfirmaTimbrajeContrib.cgi
      # bhe confirmation page 
      url = "https://loa.sii.cl/cgi_IMT/TMBECN_ConfirmaTimbrajeContrib.cgi"

      browser = check_url(browser, url)    

    rescue
      
      return false
    
    end

    browser.button(name:'cmdconfirmar').click    
    
    # url: https://loa.sii.cl/cgi_IMT/TMBECN_BoletaHonorariosElectronica.cgi
    # page with bhe data
    #url = "https://loa.sii.cl/cgi_IMT/TMBECN_BoletaHonorariosElectronica.cgi"
    #browser = check_url(browser, url)

    form = browser.element(name:'form1').locate
    hidden_input = form.element(name:'txt_codigo_barra').locate
    bar_code = hidden_input.attribute_value('value')
    frame = form.iframe(name:'prueba').locate
    extract_bhe_number = frame.attribute_value('src')
    
    tables = frame.tables
    
    a = []
    
    tables.each do |x|
      a << x
    end
    
    folio = FormatScrapped.bhe_table_5(a[4].text)
    
    given_hash = {}
    given_hash["folio"] = folio
    given_hash["codigo_barras"] = bar_code
    given_hash["rut_emisor"] = therapist_rut
    given_hash["rut_receptor"] = patient_rut
    given_hash["email_receptor"] = patient_email

    browser.element(id:'cmdenviar').click

    # url: https://loa.sii.cl/cgi_IMT/TMBECN_PresentaDatosEnvio.cgi
    # page to send email to patient
    #url = "https://loa.sii.cl/cgi_IMT/TMBECN_PresentaDatosEnvio.cgi"
    #browser = check_url(browser, url)

    input_email = browser.text_field(name:'txt_email').locate

    input_email.set "#{patient_email}"

    send_button = browser.button(id:'cmdcontinuar').locate

    send_button.click

    # email sended successfuly
    paragraph = browser.p(text:'El correo electrónico ha sido enviado exitosamente.').locate
    if paragraph.present?
      given_hash["email_enviado"] = "Si"
    else
      given_hash["email_enviado"] = "No"
    end

    result = {}
    result["datos_bhe"] = given_hash
    pretty_json = JSON.pretty_generate(result)

    browser.close

    return pretty_json

  end


  def self.total_bhe(therapist_rut,
                     password,
                     month,
                     year)

    begin

      browser = reuse_login(therapist_rut,
                           password)

      browser = check_browser_status(browser)

      url = "https://loa.sii.cl/cgi_IMT/TMBCOC_MenuConsultasContrib.cgi?dummy=1461943167534"

      browser.goto url

      browser = check_url(browser, url)

      # select month
      browser.tables.last.select_list(name:'cbmesinformemensual').select("#{month}")
      # select year
      browser.tables.last.select_list(name:'cbanoinformemensual').select("#{year}")
      # press button to see reports
      browser.buttons(id:'cmdconsultar1').first.click
      # goes to bhe created in the given month and year
      url = "https://loa.sii.cl/cgi_IMT/TMBCOC_InformeMensualBhe.cgi"

      browser = check_url(browser, url)

      response = total_bhe_bucle(browser)

      return response

    rescue

      intent = total_bhe_backup(therapist_rut,
                                password,
                                month,
                                year)
      
    end

  end

  def self.total_bhe_backup(therapist_rut,
                            password,
                            month,
                            year)

    begin

      browser = reuse_login(therapist_rut,
                           password)

      browser = check_browser_status(browser)

      url = "https://loa.sii.cl/cgi_IMT/TMBCOC_MenuConsultasContrib.cgi?dummy=1461943167534"

      browser.goto url

      browser = check_url(browser, url)

      # select month
      browser.tables.last.select_list(name:'cbmesinformemensual').select("#{month}")
      # select year
      browser.tables.last.select_list(name:'cbanoinformemensual').select("#{year}")
      # press button to see reports
      browser.buttons(id:'cmdconsultar1').first.click
      # goes to bhe created in the given month and year
      url = "https://loa.sii.cl/cgi_IMT/TMBCOC_InformeMensualBhe.cgi"

      browser = check_url(browser, url)

      response = total_bhe_bucle(browser)

      return response

    rescue

      intent = total_bhe_backup(therapist_rut,
                                password,
                                month,
                                year)
    
    end

  end

  def self.total_bhe_bucle(browser)
    outer_array = []

    if browser.link(text:'Siguiente').present?
      
      while browser.link(text:'Siguiente').present? do
        if browser.trs.any?
          browser.trs.each do |tr|
            count = 0
            if tr.tds.any? && tr.tds.count == 14
              td_array = []
              my_hash = {}
              tr.tds.each do |td|
                count += 1
                if count >= 3
                  td_array << td.text
                end
              end
              my_hash["folio"] = "#{td_array[0]}"
              my_hash["estado"] = "#{td_array[1]}"
              my_hash["fecha_tributaria"] = "#{td_array[2]}"
              my_hash["usuario"] = "#{td_array[3]}"
              my_hash["fecha_emision"] = "#{td_array[4]}"
              my_hash["sociedad_prof"] = "#{td_array[5]}"
              my_hash["rut_receptor"] = "#{td_array[6]}"
              my_hash["nombre_receptor"] = "#{td_array[7]}"
              my_hash["brutos"] = "#{td_array[8]}"
              my_hash["retiene_emisor"] = "#{td_array[9]}"
              my_hash["retiene_receptor"] = "#{td_array[10]}"
              my_hash["liquidos"] = "#{td_array[11]}" 
              outer_array << my_hash
            end
          end
        end

        #outer_array.shift
        
        browser.link(text:'Siguiente').click
        
        if !browser.link(text:'Siguiente').present?
          
          if browser.trs.any?
            browser.trs.each do |tr|
              count = 0
              if tr.tds.any? && tr.tds.count == 14
                td_array = []
                my_hash = {}
                tr.tds.each do |td|
                  count += 1
                  if count >= 3
                    td_array << td.text
                  end
                end
                my_hash["folio"] = "#{td_array[0]}"
                my_hash["estado"] = "#{td_array[1]}"
                my_hash["fecha_tributaria"] = "#{td_array[2]}"
                my_hash["usuario"] = "#{td_array[3]}"
                my_hash["fecha_emision"] = "#{td_array[4]}"
                my_hash["sociedad_prof"] = "#{td_array[5]}"
                my_hash["rut_receptor"] = "#{td_array[6]}"
                my_hash["nombre_receptor"] = "#{td_array[7]}"
                my_hash["brutos"] = "#{td_array[8]}"
                my_hash["retiene_emisor"] = "#{td_array[9]}"
                my_hash["retiene_receptor"] = "#{td_array[10]}"
                my_hash["liquidos"] = "#{td_array[11]}" 
                outer_array << my_hash
              end
            end
          end
        end

        #outer_array.shift

      end

    else

      if browser.trs.any?
        browser.trs.each do |tr|
          count = 0
          if tr.tds.any? && tr.tds.count == 14
            td_array = []
            my_hash = {}
            tr.tds.each do |td|
              count += 1
              if count >= 3
                td_array << td.text
              end
            end
            my_hash["folio"] = "#{td_array[0]}"
            my_hash["estado"] = "#{td_array[1]}"
            my_hash["fecha_tributaria"] = "#{td_array[2]}"
            my_hash["usuario"] = "#{td_array[3]}"
            my_hash["fecha_emision"] = "#{td_array[4]}"
            my_hash["sociedad_prof"] = "#{td_array[5]}"
            my_hash["rut_receptor"] = "#{td_array[6]}"
            my_hash["nombre_receptor"] = "#{td_array[7]}"
            my_hash["brutos"] = "#{td_array[8]}"
            my_hash["retiene_emisor"] = "#{td_array[9]}"
            my_hash["retiene_receptor"] = "#{td_array[10]}"
            my_hash["liquidos"] = "#{td_array[11]}" 
            outer_array << my_hash
          end
        end
      end
        
      #outer_array.shift

    end

    outer_array.delete({"folio"=>"N°", "estado"=>"Estado", "fecha_tributaria"=>"Fecha", "usuario"=>"Usuario", "fecha_emision"=>"Fecha", "sociedad_prof"=>"Soc. Prof.", "rut_receptor"=>"Rut", "nombre_receptor"=>"Nombre o Razón Social", "brutos"=>"Brutos", "retiene_emisor"=>"Ret. Emisor", "retiene_receptor"=>"Ret. Receptor", "liquidos"=>"Líquidos"})
    pretty_json = JSON.pretty_generate(outer_array)
    
    browser.close

    return pretty_json
  end

  def self.delete_bhe(therapist_rut,
                      password,
                      bhe_number)
    
    given_therapist = therapist_rut
    given_password = password
    given_bhe = bhe_number

    begin
      
      browser = reuse_login(therapist_rut,
                           password)
      
      browser = check_browser_status(browser)
      
      url = "https://loa.sii.cl/cgi_IMT/TMBANU_PrevalidaAnulacion.cgi?dummy=1461943341054"
      
      browser.goto url

      # check that browser is in opcion de eliminar boleta
      browser = check_url(browser, url)

     
      browser.text_field(name:'Txt_BoletaAnular').set "#{bhe_number}"

      browser.radio(value:'3').select

      browser.button(id:'cmdContinuar').click

      browser = check_given_element(browser,
                 'BtnConfirmar')

      delete_bhe_click_window(browser)

    rescue

      puts "retrying"
      intent = delete_bhe(given_therapist,
                          given_password,
                          given_bhe)
      #return false

    end

  end

  def self.delete_bhe_click_window(browser)

    begin

      browser.button(name:'BtnConfirmar').click 
      
      sleep 1

      browser.alert.ok

      browser.close
        
      return true

    rescue
      
      puts "something happened clicking the alert.rescue"

    else
    
      puts "something happened clicking the alert.else"

      return false

    end

  end

  def self.user_retains(therapist_rut, 
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
                        sii_date)
    begin
      
      date = FormatScrapped.bhe_date(sii_date)

      browser = reuse_login(therapist_rut,
                           password)
      
      browser = check_browser_status(browser)

      patient_rut_without_dv = patient_rut.split("")
      dv = patient_rut_without_dv.last
      patient_rut_without_dv.pop
      final_patient_rut = patient_rut_without_dv.join

      # url: https://loa.sii.cl/cgi_IMT/TMBECN_ValidaTimbrajeContrib.cgi?modo=1&dummy=1461943054813
      # goes to page where is needed to decide to choose tax retains or not
      url = "https://loa.sii.cl/cgi_IMT/TMBECN_ValidaTimbrajeContrib.cgi?modo=1&dummy=1461943054813"
      
      browser.goto url

      browser = check_url(browser, url)

      radio = browser.radio(value:'RETCONTRIBUYENTE')
            
      radio.select

      browser.button(id:'cmdContinuar').click

      # url: https://loa.sii.cl/cgi_IMT/TMBECN_PresentaDatosBoleta.cgi
      # check page where a user needs to send his personal info
      url = "https://loa.sii.cl/cgi_IMT/TMBECN_PresentaDatosBoleta.cgi"

      browser = check_url(browser, url)

      # selects day
      browser.select_list(name:'cbo_dia_boleta').select("#{date[0]}")
      # selects month
      browser.select_list(name:'cbo_mes_boleta').select("#{date[1]}")
      # selects year
      browser.select_list(name:'cbo_anio_boleta').select("#{date[2]}")
      # rut with no dv (incomplete)
      browser.text_field(name:'txt_rut_destinatario').set "#{final_patient_rut}"
      browser.text_field(name:'txt_dv_destinatario').set "#{dv}"
      browser.text_field(name:'txt_domicilio_destinatario').set "#{domicilio}"
      
      browser.select_list(name:'cod_region').click
      browser.option(text:"#{region}").click

      browser.select_list(name:'cbo_comuna').click
      browser.option(text:"#{comuna}").click
      #comuna.select(text: 'PROVIDENCIA')
      #sleep 2

      browser.text_field(id:'desc_prestacion_1').set "#{glosa_1}"
      browser.text_field(id:'valor_prestacion_1').set "#{valor_1}"
      # if all goes fine it should change page
      browser.button(name:'cmdAceptar').click


      # url: https://loa.sii.cl/cgi_IMT/TMBECN_ConfirmaTimbrajeContrib.cgi
      # bhe confirmation page 
      url = "https://loa.sii.cl/cgi_IMT/TMBECN_ConfirmaTimbrajeContrib.cgi"

      browser = check_url(browser, url)    

    rescue
      
      return false
    
    end

    browser.button(name:'cmdconfirmar').click    
    
    # url: https://loa.sii.cl/cgi_IMT/TMBECN_BoletaHonorariosElectronica.cgi
    # page with bhe data
    #url = "https://loa.sii.cl/cgi_IMT/TMBECN_BoletaHonorariosElectronica.cgi"
    #browser = check_url(browser, url)

    form = browser.element(name:'form1').locate
    hidden_input = form.element(name:'txt_codigo_barra').locate
    bar_code = hidden_input.attribute_value('value')
    frame = form.iframe(name:'prueba').locate
    extract_bhe_number = frame.attribute_value('src')
    
    tables = frame.tables
    
    a = []
    
    tables.each do |x|
      a << x
    end
    
    folio = FormatScrapped.bhe_table_5(a[4].text)
    
    given_hash = {}
    given_hash["folio"] = folio
    given_hash["codigo_barras"] = bar_code
    given_hash["rut_emisor"] = therapist_rut
    given_hash["rut_receptor"] = patient_rut
    given_hash["email_receptor"] = patient_email

    browser.element(id:'cmdenviar').click

    # url: https://loa.sii.cl/cgi_IMT/TMBECN_PresentaDatosEnvio.cgi
    # page to send email to patient
    #url = "https://loa.sii.cl/cgi_IMT/TMBECN_PresentaDatosEnvio.cgi"
    #browser = check_url(browser, url)

    input_email = browser.text_field(name:'txt_email').locate

    input_email.set "#{patient_email}"

    send_button = browser.button(id:'cmdcontinuar').locate

    send_button.click

    # email sended successfuly
    paragraph = browser.p(text:'El correo electrónico ha sido enviado exitosamente.').locate
    if paragraph.present?
      given_hash["email_enviado"] = "Si"
    else
      given_hash["email_enviado"] = "No"
    end

    result = {}
    result["datos_bhe"] = given_hash
    pretty_json = JSON.pretty_generate(result)

    browser.close

    return pretty_json

  end

  def self.check_url(browser, url)
    sleep 1
    if browser.url == "#{url}"
      return browser
    else
      sleep 1
      browser.close
      return false
    end
  end

  def self.check_browser_status(browser)
    sleep 1
    if browser != false && browser != nil
      return browser
    else
      return false
    end
  end

  def self.check_given_element(browser, 
                               id_name_value)
    sleep 1
    if browser.element(name:"#{id_name_value}").present?
      return browser
    else
      browser.close
      return false
    end
  end

  def self.sleep_time(browser)
    now = Time.now
    transcurred_time = 1
    while transcurred_time <= 7 do
      check_time = Time.now
      transcurred_time = (check_time - now).to_i
      # function with browser
      browser = true
      
      if browser != true && browser != nil
      
        return browser
      
      else

        sleep 1

        if transcurred_time >=6
          #browser.close
          return false
        end

      end
      # End function with browser
      
    end
  end

end
