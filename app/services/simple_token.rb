class SimpleToken
  
  def self.call
    t1 = Time.now 
  	random_token = SecureRandom.urlsafe_base64
    t2 = Time.now
    t3 = t2 - t1 
    puts "#{t3} seconds"
    return random_token
  end

end