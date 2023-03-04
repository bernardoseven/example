class Failing

  def self.to_fail(a,b)
  	begin
  	  c = a / b
  	rescue
  	  return false
  	ensure
  	  #return c
  	end
  end

end