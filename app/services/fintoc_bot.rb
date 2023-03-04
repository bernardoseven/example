require 'kimurai'
require 'mechanize'
require 'capybara'
require 'nokogiri'
require 'open-uri'
require 'watir'
require 'json'

class FintocBot
  
  # FintocBot.hello
  def self.hello
  	puts "hello"
  end

  # FintocBot.login("bernardoseven@gmail.com","fhg5fhg5")
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



end