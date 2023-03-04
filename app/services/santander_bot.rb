require 'watir'
require 'headless'

class SantanderBot

  def self.login(therapist_rut,
                 password)

    if Rails.env.production?
      args = ['--no-sandbox',
              '--disable-extensions',
              '--ignore-certificate-errors',
              '--width=1920',
              '--height=1080',
              '--headless']
              # remember to add --headless
      browser = Watir::Browser.new :firefox, options: {args: args}
    else
      args = ['--no-sandbox',
              '--disable-extensions',
              '--ignore-certificate-errors',
              '--width=1920',
              '--height=1080',
              '--headless']
              # remember to add --headless
      browser = Watir::Browser.new :firefox, options: {args: args}
    end

    browser.goto 'https://banco.santander.cl/personas'
    
    # add some code to exit the browser if a given element obscures
    # another one
    now = Time.now

    check_time = Time.now

    transcurred_time = (check_time - now).to_i
    
    while transcurred_time <= 27 do 

      if browser.link(id:'btnIngresar').present?
        
        browser.link(id:'btnIngresar').click

        browser.text_field(class:["input", "rut"]).click
      browser.text_field(class:["input", "rut"]).set "#{therapist_rut}"
     
      browser.text_field(class:["input", "pin"]).click
      browser.text_field(class:["input", "pin"]).set "#{password}"

      browser.button(class:'btn-login').click

        if browser.frameset.frame(id:'1').present?
        
          browser.close
          return true

        else
          browser.close
          return false
        end
      
      else
      
        puts "buscando"
        sleep 0.5
      
      end

      check_time = Time.now
      transcurred_time = (check_time - now).to_i

      if transcurred_time >= 25
        browser.close
        return false
      end

    end

  end

  def self.reuse_login(therapist_rut,
               password)

    if Rails.env.production?
      args = ['--no-sandbox',
              '--disable-extensions',
              '--ignore-certificate-errors',
              '--headless'
              ]
              # remember to add --headless
      browser = Watir::Browser.new :firefox, options: {args: args}
    else
      args = ['--no-sandbox',
              '--disable-extensions',
              '--ignore-certificate-errors',
              '--headless']
              # remember to add --headless
      browser = Watir::Browser.new :firefox, options: {args: args}
    end

    browser.goto 'https://banco.santander.cl/personas'
    
    # add some code to exit the browser if a given element obscures
    # another one
    now = Time.now

    check_time = Time.now

    transcurred_time = (check_time - now).to_i
    
    while transcurred_time <= 27 do 

      if browser.link(id:'btnIngresar').present?
        
        browser.link(id:'btnIngresar').click

        browser.text_field(class:["input", "rut"]).click
        browser.text_field(class:["input", "rut"]).set "#{therapist_rut}"
       
        browser.text_field(class:["input", "pin"]).click
        browser.text_field(class:["input", "pin"]).set "#{password}"

        browser.button(class:'btn-login').click

        if browser.frameset.frame(id:'1').present?
        
          return browser

        else

          browser.close
          return false
        
        end
      
      else
      
        puts "buscando"
        sleep 0.5
      
      end

      check_time = Time.now
      transcurred_time = (check_time - now).to_i

      if transcurred_time >= 25

        browser.close
        return false

      end

    end

  end

  # SantanderBot.cartola_historica("94684501","9205","Noviembre","2021")
  def self.cartola_historica(therapist_rut,
                             password,
                             month,
                             year)

    begin

      browser = reuse_login(therapist_rut,
                            password)

      browser = check_browser_status(browser)

      browser.frameset.frame(id:'2').element(id:'menu').element(id:'CU1').click
      
      browser.frameset.frame(id:'2').element(id:'CC2').click
      
      browser.frameset.frame(id:'2').element(id:'CH3').click

      browser.frameset.frame(id:'2').iframe(id:'p4').select_list(name:'mes0').click

      browser.frameset.frame(id:'2').iframe(id:'p4').option(text:"#{month}").click

      browser.frameset.frame(id:'2').iframe(id:'p4').select_list(name:"anno0").click

      browser.frameset.frame(id:'2').iframe(id:'p4').option(text:"#{year}").click

      browser.frameset.frame(id:'2').iframe(id:'p4').button(name:'BtnPER_Ver').click

      array = []

      if browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Siguiente').present?

        while browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Siguiente').present? do 

          parse = Nokogiri::HTML.parse(browser.html)

          trs = parse.css('[name="abrev"]', '[name="FRMCCHEF"]',' table tr')
          trs.each do |tr|
            my_hash = {}
            td_array = []
            if tr.css('td').count == 7
              tr.css('td').each do |td_text|
                td_array << td_text.text.squish
              end 
            end
            my_hash["fecha"] = "#{td_array[0]}"
            my_hash["sucursal"] = "#{td_array[1]}"
            my_hash["descripcion"] = "#{td_array[2]}"
            my_hash["n_documento"] = "#{td_array[3]}"
            my_hash["cargos"] = "#{td_array[4]}"
            my_hash["abonos"] = "#{td_array[5]}"
            my_hash["saldo"] = "#{td_array[6]}"
            array << my_hash
          end

          browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Siguiente').click

          if !browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Siguiente').present?

            parse = Nokogiri::HTML.parse(browser.html)

            trs = parse.css('[name="abrev"]', '[name="FRMCCHEF"]',' table tr')
            trs.each do |tr|
              my_hash = {}
              td_array = []
              if tr.css('td').count == 7
                tr.css('td').each do |td_text|
                  td_array << td_text.text.squish
                end 
              end
              my_hash["fecha"] = "#{td_array[0]}"
              my_hash["sucursal"] = "#{td_array[1]}"
              my_hash["descripcion"] = "#{td_array[2]}"
              my_hash["n_documento"] = "#{td_array[3]}"
              my_hash["cargos"] = "#{td_array[4]}"
              my_hash["abonos"] = "#{td_array[5]}"
              my_hash["saldo"] = "#{td_array[6]}"
              array << my_hash
            end

          end

        end

      else

        parse = Nokogiri::HTML.parse(browser.html)

        trs = parse.css('[name="abrev"]', '[name="FRMCCHEF"]',' table tr')
        trs.each do |tr|
          my_hash = {}
          td_array = []
          if tr.css('td').count == 7
            tr.css('td').each do |td_text|
              td_array << td_text.text.squish
            end 
          end
          my_hash["fecha"] = "#{td_array[0]}"
          my_hash["sucursal"] = "#{td_array[1]}"
          my_hash["descripcion"] = "#{td_array[2]}"
          my_hash["n_documento"] = "#{td_array[3]}"
          my_hash["cargos"] = "#{td_array[4]}"
          my_hash["abonos"] = "#{td_array[5]}"
          my_hash["saldo"] = "#{td_array[6]}"
          array << my_hash
        end

      end    

      array.delete({"fecha"=>"", "sucursal"=>"", "descripcion"=>"", "n_documento"=>"", "cargos"=>"", "abonos"=>"", "saldo"=>""})
      array.delete({"fecha"=>"Fecha", "sucursal"=>"Sucursal", "descripcion"=>"Descripción", "n_documento"=>"Nº Documento", "cargos"=>"Cheques y Otros Cargos", "abonos"=>"Depósitos y Abonos", "saldo"=>"Saldo"})

      pretty_json = JSON.pretty_generate(array)

      browser.close

      return pretty_json

    rescue

      puts "trying first"
      intent = cartola_historica_backup(therapist_rut,
                                        password,
                                        month,
                                        year)

    end

  end

  def self.cartola_historica_backup(therapist_rut,
                                    password,
                                    month,
                                    year)

    begin

      browser = reuse_login(therapist_rut,
                            password)

      browser = check_browser_status(browser)

      browser.frameset.frame(id:'2').element(id:'menu').element(id:'CU1').click
      
      browser.frameset.frame(id:'2').element(id:'CC2').click
      
      browser.frameset.frame(id:'2').element(id:'CH3').click

      browser.frameset.frame(id:'2').iframe(id:'p4').select_list(name:'mes0').click

      browser.frameset.frame(id:'2').iframe(id:'p4').option(text:"#{month}").click

      browser.frameset.frame(id:'2').iframe(id:'p4').select_list(name:"anno0").click

      browser.frameset.frame(id:'2').iframe(id:'p4').option(text:"#{year}").click

      browser.frameset.frame(id:'2').iframe(id:'p4').button(name:'BtnPER_Ver').click

      array = []

      if browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Siguiente').present?

        while browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Siguiente').present? do 

          parse = Nokogiri::HTML.parse(browser.html)

          trs = parse.css('[name="abrev"]', '[name="FRMCCHEF"]',' table tr')
          trs.each do |tr|
            my_hash = {}
            td_array = []
            if tr.css('td').count == 7
              tr.css('td').each do |td_text|
                td_array << td_text.text.squish
              end 
            end
            my_hash["fecha"] = "#{td_array[0]}"
            my_hash["sucursal"] = "#{td_array[1]}"
            my_hash["descripcion"] = "#{td_array[2]}"
            my_hash["n_documento"] = "#{td_array[3]}"
            my_hash["cargos"] = "#{td_array[4]}"
            my_hash["abonos"] = "#{td_array[5]}"
            my_hash["saldo"] = "#{td_array[6]}"
            array << my_hash
          end

          browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Siguiente').click

          if !browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Siguiente').present?

            parse = Nokogiri::HTML.parse(browser.html)

            trs = parse.css('[name="abrev"]', '[name="FRMCCHEF"]',' table tr')
            trs.each do |tr|
              my_hash = {}
              td_array = []
              if tr.css('td').count == 7
                tr.css('td').each do |td_text|
                  td_array << td_text.text.squish
                end 
              end
              my_hash["fecha"] = "#{td_array[0]}"
              my_hash["sucursal"] = "#{td_array[1]}"
              my_hash["descripcion"] = "#{td_array[2]}"
              my_hash["n_documento"] = "#{td_array[3]}"
              my_hash["cargos"] = "#{td_array[4]}"
              my_hash["abonos"] = "#{td_array[5]}"
              my_hash["saldo"] = "#{td_array[6]}"
              array << my_hash
            end

          end

        end

      else

        parse = Nokogiri::HTML.parse(browser.html)

        trs = parse.css('[name="abrev"]', '[name="FRMCCHEF"]',' table tr')
        trs.each do |tr|
          my_hash = {}
          td_array = []
          if tr.css('td').count == 7
            tr.css('td').each do |td_text|
              td_array << td_text.text.squish
            end 
          end
          my_hash["fecha"] = "#{td_array[0]}"
          my_hash["sucursal"] = "#{td_array[1]}"
          my_hash["descripcion"] = "#{td_array[2]}"
          my_hash["n_documento"] = "#{td_array[3]}"
          my_hash["cargos"] = "#{td_array[4]}"
          my_hash["abonos"] = "#{td_array[5]}"
          my_hash["saldo"] = "#{td_array[6]}"
          array << my_hash
        end

      end    

      array.delete({"fecha"=>"", "sucursal"=>"", "descripcion"=>"", "n_documento"=>"", "cargos"=>"", "abonos"=>"", "saldo"=>""})
      array.delete({"fecha"=>"Fecha", "sucursal"=>"Sucursal", "descripcion"=>"Descripción", "n_documento"=>"Nº Documento", "cargos"=>"Cheques y Otros Cargos", "abonos"=>"Depósitos y Abonos", "saldo"=>"Saldo"})

      pretty_json = JSON.pretty_generate(array)

      browser.close

      return pretty_json

    rescue

      puts "trying in backup"
      intent = cartola_historica(therapist_rut,
                                 password,
                                 month,
                                 year)

    end

  end

  # SantanderBot.cartola_actual("94684501","9205")
  def self.cartola_actual(therapist_rut,
                          password)

    begin

      browser = reuse_login(therapist_rut, password)

      browser = check_browser_status(browser)

      browser.frameset.frame(id:'2').element(id:'menu').element(id:'UMN').click

      browser.frameset.frame(id:'2').element(id:'UMA').click

      array = []

      sleep 2

      if browser.frameset.frame(id:'2').iframe(id:'p4').radios.any?
        
        browser.frameset.frame(id:'2').iframe(id:'p4').radios.first.select

        browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Aceptar').click

        sleep 1

        browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Cartola por Emitir').click

        if browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').present?

          while browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').present? do 
            
            parse = Nokogiri::HTML.parse(browser.html)

            trs = parse.css(' table table tr')

            trs.each do |tr|
              my_hash = {}
              td_array = []
              if tr.css('td').count == 6
                tr.css('td').each do |td_text|
                  td_array << td_text.text.squish
                end 
              end
              my_hash["fecha"] = "#{td_array[0]}"
              my_hash["cargos"] = "#{td_array[1]}"
              my_hash["abonos"] = "#{td_array[2]}"
              my_hash["descripcion"] = "#{td_array[3]}"
              my_hash["saldo"] = "#{td_array[4]}"
              my_hash["n_documento"] = "#{td_array[5]}"
              array << my_hash
            end

            browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').click

            if !browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').present?

              parse = Nokogiri::HTML.parse(browser.html)

              trs = parse.css(' table table tr')

              trs.each do |tr|
                my_hash = {}
                td_array = []
                if tr.css('td').count == 6
                  tr.css('td').each do |td_text|
                    td_array << td_text.text.squish
                  end 
                end
                my_hash["fecha"] = "#{td_array[0]}"
                my_hash["cargos"] = "#{td_array[1]}"
                my_hash["abonos"] = "#{td_array[2]}"
                my_hash["descripcion"] = "#{td_array[3]}"
                my_hash["saldo"] = "#{td_array[4]}"
                my_hash["n_documento"] = "#{td_array[5]}"
                array << my_hash
              end

            end

          end

        else

          parse = Nokogiri::HTML.parse(browser.html)

          trs = parse.css(' table table tr')

          trs.each do |tr|
            my_hash = {}
            td_array = []
            if tr.css('td').count == 6
              tr.css('td').each do |td_text|
                td_array << td_text.text.squish
              end 
            end
            my_hash["fecha"] = "#{td_array[0]}"
            my_hash["cargos"] = "#{td_array[1]}"
            my_hash["abonos"] = "#{td_array[2]}"
            my_hash["descripcion"] = "#{td_array[3]}"
            my_hash["saldo"] = "#{td_array[4]}"
            my_hash["n_documento"] = "#{td_array[5]}"
            array << my_hash
          end

        end

        array.delete({"fecha"=>"", "cargos"=>"", "abonos"=>"", "descripcion"=>"", "saldo"=>"", "n_documento"=>""})     
        array.delete({"fecha"=>"Fecha", "cargos"=>"Cargo ($)", "abonos"=>"Abono ($)", "descripcion"=>"Descripción", "saldo"=>"Saldo Diario", "n_documento"=>"Documento"})

        pretty_json = JSON.pretty_generate(array)

        browser.close

        return pretty_json

      else

        sleep 1
        
        browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Cartola por Emitir').click   

        if browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').present?

          while browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').present? do
          
            parse = Nokogiri::HTML.parse(browser.html)

            trs = parse.css(' table table tr')

            trs.each do |tr|
              my_hash = {}
              td_array = []
              if tr.css('td').count == 6
                tr.css('td').each do |td_text|
                  td_array << td_text.text.squish
                end 
              end
              my_hash["fecha"] = "#{td_array[0]}"
              my_hash["cargos"] = "#{td_array[1]}"
              my_hash["abonos"] = "#{td_array[2]}"
              my_hash["descripcion"] = "#{td_array[3]}"
              my_hash["saldo"] = "#{td_array[4]}"
              my_hash["n_documento"] = "#{td_array[5]}"
              array << my_hash
            end

            browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').click

            if !browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').present?

              parse = Nokogiri::HTML.parse(browser.html)

              trs = parse.css(' table table tr')

              trs.each do |tr|
                my_hash = {}
                td_array = []
                if tr.css('td').count == 6
                  tr.css('td').each do |td_text|
                    td_array << td_text.text.squish
                  end 
                end
                my_hash["fecha"] = "#{td_array[0]}"
                my_hash["cargos"] = "#{td_array[1]}"
                my_hash["abonos"] = "#{td_array[2]}"
                my_hash["descripcion"] = "#{td_array[3]}"
                my_hash["saldo"] = "#{td_array[4]}"
                my_hash["n_documento"] = "#{td_array[5]}"
                array << my_hash
              end

            end

          end

        else

          parse = Nokogiri::HTML.parse(browser.html)

          trs = parse.css(' table table tr')

          trs.each do |tr|
            my_hash = {}
            td_array = []
            if tr.css('td').count == 6
              tr.css('td').each do |td_text|
                td_array << td_text.text.squish
              end 
            end
            my_hash["fecha"] = "#{td_array[0]}"
            my_hash["cargos"] = "#{td_array[1]}"
            my_hash["abonos"] = "#{td_array[2]}"
            my_hash["descripcion"] = "#{td_array[3]}"
            my_hash["saldo"] = "#{td_array[4]}"
            my_hash["n_documento"] = "#{td_array[5]}"
            array << my_hash
          end

        end
       
        array.delete({"fecha"=>"", "cargos"=>"", "abonos"=>"", "descripcion"=>"", "saldo"=>"", "n_documento"=>""})     
        array.delete({"fecha"=>"Fecha", "cargos"=>"Cargo ($)", "abonos"=>"Abono ($)", "descripcion"=>"Descripción", "saldo"=>"Saldo Diario", "n_documento"=>"Documento"})

        pretty_json = JSON.pretty_generate(array)

        browser.close

        return pretty_json

      end

    rescue

      puts "trying first"
      intent = cartola_actual_backup(therapist_rut,
                          password)

    end 

  end

  def self.cartola_actual_backup(therapist_rut,
                          password)

    begin

      browser = reuse_login(therapist_rut, password)

      browser = check_browser_status(browser)

      browser.frameset.frame(id:'2').element(id:'menu').element(id:'UMN').click

      browser.frameset.frame(id:'2').element(id:'UMA').click

      array = []

      sleep 2

      if browser.frameset.frame(id:'2').iframe(id:'p4').radios.any?
        
        browser.frameset.frame(id:'2').iframe(id:'p4').radios.first.select

        browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Aceptar').click

        sleep 1

        browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Cartola por Emitir').click

        if browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').present?

          while browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').present? do 
            
            parse = Nokogiri::HTML.parse(browser.html)

            trs = parse.css(' table table tr')

            trs.each do |tr|
              my_hash = {}
              td_array = []
              if tr.css('td').count == 6
                tr.css('td').each do |td_text|
                  td_array << td_text.text.squish
                end 
              end
              my_hash["fecha"] = "#{td_array[0]}"
              my_hash["cargos"] = "#{td_array[1]}"
              my_hash["abonos"] = "#{td_array[2]}"
              my_hash["descripcion"] = "#{td_array[3]}"
              my_hash["saldo"] = "#{td_array[4]}"
              my_hash["n_documento"] = "#{td_array[5]}"
              array << my_hash
            end

            browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').click

            if !browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').present?

              parse = Nokogiri::HTML.parse(browser.html)

              trs = parse.css(' table table tr')

              trs.each do |tr|
                my_hash = {}
                td_array = []
                if tr.css('td').count == 6
                  tr.css('td').each do |td_text|
                    td_array << td_text.text.squish
                  end 
                end
                my_hash["fecha"] = "#{td_array[0]}"
                my_hash["cargos"] = "#{td_array[1]}"
                my_hash["abonos"] = "#{td_array[2]}"
                my_hash["descripcion"] = "#{td_array[3]}"
                my_hash["saldo"] = "#{td_array[4]}"
                my_hash["n_documento"] = "#{td_array[5]}"
                array << my_hash
              end

            end

          end

        else

          parse = Nokogiri::HTML.parse(browser.html)

          trs = parse.css(' table table tr')

          trs.each do |tr|
            my_hash = {}
            td_array = []
            if tr.css('td').count == 6
              tr.css('td').each do |td_text|
                td_array << td_text.text.squish
              end 
            end
            my_hash["fecha"] = "#{td_array[0]}"
            my_hash["cargos"] = "#{td_array[1]}"
            my_hash["abonos"] = "#{td_array[2]}"
            my_hash["descripcion"] = "#{td_array[3]}"
            my_hash["saldo"] = "#{td_array[4]}"
            my_hash["n_documento"] = "#{td_array[5]}"
            array << my_hash
          end

        end

        array.delete({"fecha"=>"", "cargos"=>"", "abonos"=>"", "descripcion"=>"", "saldo"=>"", "n_documento"=>""})     
        array.delete({"fecha"=>"Fecha", "cargos"=>"Cargo ($)", "abonos"=>"Abono ($)", "descripcion"=>"Descripción", "saldo"=>"Saldo Diario", "n_documento"=>"Documento"})

        pretty_json = JSON.pretty_generate(array)

        browser.close

        return pretty_json

      else

        sleep 1
        
        browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Cartola por Emitir').click   

        if browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').present?

          while browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').present? do
          
            parse = Nokogiri::HTML.parse(browser.html)

            trs = parse.css(' table table tr')

            trs.each do |tr|
              my_hash = {}
              td_array = []
              if tr.css('td').count == 6
                tr.css('td').each do |td_text|
                  td_array << td_text.text.squish
                end 
              end
              my_hash["fecha"] = "#{td_array[0]}"
              my_hash["cargos"] = "#{td_array[1]}"
              my_hash["abonos"] = "#{td_array[2]}"
              my_hash["descripcion"] = "#{td_array[3]}"
              my_hash["saldo"] = "#{td_array[4]}"
              my_hash["n_documento"] = "#{td_array[5]}"
              array << my_hash
            end

            browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').click

            if !browser.frameset.frame(id:'2').iframe(id:'p4').button(value:'Continuar').present?

              parse = Nokogiri::HTML.parse(browser.html)

              trs = parse.css(' table table tr')

              trs.each do |tr|
                my_hash = {}
                td_array = []
                if tr.css('td').count == 6
                  tr.css('td').each do |td_text|
                    td_array << td_text.text.squish
                  end 
                end
                my_hash["fecha"] = "#{td_array[0]}"
                my_hash["cargos"] = "#{td_array[1]}"
                my_hash["abonos"] = "#{td_array[2]}"
                my_hash["descripcion"] = "#{td_array[3]}"
                my_hash["saldo"] = "#{td_array[4]}"
                my_hash["n_documento"] = "#{td_array[5]}"
                array << my_hash
              end

            end

          end

        else

          parse = Nokogiri::HTML.parse(browser.html)

          trs = parse.css(' table table tr')

          trs.each do |tr|
            my_hash = {}
            td_array = []
            if tr.css('td').count == 6
              tr.css('td').each do |td_text|
                td_array << td_text.text.squish
              end 
            end
            my_hash["fecha"] = "#{td_array[0]}"
            my_hash["cargos"] = "#{td_array[1]}"
            my_hash["abonos"] = "#{td_array[2]}"
            my_hash["descripcion"] = "#{td_array[3]}"
            my_hash["saldo"] = "#{td_array[4]}"
            my_hash["n_documento"] = "#{td_array[5]}"
            array << my_hash
          end

        end
       
        array.delete({"fecha"=>"", "cargos"=>"", "abonos"=>"", "descripcion"=>"", "saldo"=>"", "n_documento"=>""})     
        array.delete({"fecha"=>"Fecha", "cargos"=>"Cargo ($)", "abonos"=>"Abono ($)", "descripcion"=>"Descripción", "saldo"=>"Saldo Diario", "n_documento"=>"Documento"})

        pretty_json = JSON.pretty_generate(array)

        browser.close

        return pretty_json

      end

    rescue

      puts "trying in backup"
      intent = cartola_actual(therapist_rut,
                          password)

    end 

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

end


