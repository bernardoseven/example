class FormatScrapped

  def self.bhe_table_5(given_string)
    array = given_string.split("")
    count = array.count
    last_index = count - 1
    final_array = []

    statement = true
    while statement == true do 
      evaluate = array[last_index]
      if evaluate != " "
        final_array.prepend(evaluate)
      else
      	statement = false
      end
      last_index -= 1
    end

    folio = final_array.join("").to_i

    return folio
  end

  def self.bhe_date(given_string)
    date = given_string.to_date
    day = date.day
    if day.to_s.length < 2
      new_day = "0" + day.to_s
    else
      new_day = day.to_s
    end
    month = date.month
    if month.to_s.length < 2
      new_month = "0" + month.to_s
    else
      new_month = month.to_s
    end
    new_year = date.year.to_s

    return new_day, new_month, new_year
  end

end