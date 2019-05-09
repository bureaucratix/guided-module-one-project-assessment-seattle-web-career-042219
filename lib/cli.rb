Qol_pref_string_hash = {housing_pref: "Housing",
 cost_of_living_pref: "Cost of Living",
startups_pref: "Startups",
venture_capital_pref: "Venture Capital",
travel_connectivity_pref: "Travel Connectivity",
commute_pref: "Commute",
business_freedom_pref: "Business Freedom",
safety_pref: "Safety",
healthcare_pref: "Healthcare",
education_pref: "Education",
environmental_quality_pref: "Environmental Quality",
economy_pref: "Economy",
taxation_pref: "Taxation",
internet_access_pref: "Internet Access",
leisure_and_culture_pref: "Leisure and Culture",
tolerance_pref: "Tolerance",
outdoors_pref: "Outdoors"}
Qol_string_hash = {housing: "Housing",
cost_of_living: "Cost of Living",
startups: "Startups",
venture_capital: "Venture Capital",
travel_connectivity: "Travel Connectivity",
commute: "Commute",
business_freedom: "Business Freedom",
safety: "Safety",
healthcare: "Healthcare",
education: "Education",
environmental_quality: "Environmental Quality",
economy: "Economy",
taxation: "Taxation",
internet_access: "Internet Access",
leisure_and_culture: "Leisure and Culture",
tolerance: "Tolerance",
outdoors: "Outdoors"}

def welcome
  puts "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~".yellow
  puts "Welcome to City Quality of Life (CQL)! What's your username?".blue
  puts "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~".yellow
end

def get_name
  gets.chomp
end

# returns object, or nil if new user
def look_for_user(name)
  User.find_by name: name
end

#creates and returns new user
def new_user(name)
  User.create(name: name)
end

def help
  puts 'Here are the things you can do:'.blue.underline
  puts '-- find: Find a city / add it to your list!'
  puts '-- list: View your current list of cities'
  puts '-- preferences: View and update your personal preferences'
  puts '-- exit: Exit the application'
end

######################FIND#######################

def get_city_input
  puts 'Enter the name of a city:'.green
  gets.chomp
end

#takes city name and shows list to choose one city
def choose_city(city_query)
  response_string = RestClient.get("https://api.teleport.org/api/cities/?search=#{city_query}&embed=city%3Asearch-results%2Fcity%3Aitem%2Fcity%3Aurban_area%2Fua%3Ascores")
  response_hash = JSON.parse(response_string)
  if response_hash['_embedded']['city:search-results'].empty?
    puts "No matches found!
    \nBringing you back to the main menu!\n ".cyan
    return nil
  elsif response_hash['_embedded']['city:search-results'].length == 1
    return response_hash['_embedded']['city:search-results'][0]
  else
    puts ''
    response_hash['_embedded']['city:search-results'].each_with_index do |city_hash, index|
      puts "#{index + 1}. #{city_hash['_embedded']['city:item']['full_name']}"
    end
    puts ''
    puts 'Please enter the number of the city you would like to view.'.green
    # #fix for invalid inputs
    input = gets.chomp.to_i
    return response_hash['_embedded']['city:search-results'][input - 1]
  end
end

#find/creates UrbanArea and City objects/tables
def get_city_from_api(city_hash)
  city_name = city_hash['_embedded']['city:item']['name']
  city_population = city_hash['_embedded']['city:item']['population']
  if city_hash['_embedded']['city:item']['_embedded'].nil?
    puts "Sorry, this city does not belong to an urban area with Quality of Life data! :( \nBringing you back to the main menu!\n ".cyan
    return nil
  else
    urban_area_state = city_hash['_embedded']['city:item']['full_name'].split(', ')[1]
    urban_area = city_hash['_embedded']['city:item']['_embedded']['city:urban_area']
    urban_area_name = urban_area['name']
    housing = urban_area['_embedded']['ua:scores']['categories'][0]['score_out_of_10']
    cost_of_living = urban_area['_embedded']['ua:scores']['categories'][1]['score_out_of_10']
    startups = urban_area['_embedded']['ua:scores']['categories'][2]['score_out_of_10']
    venture_capital = urban_area['_embedded']['ua:scores']['categories'][3]['score_out_of_10']
    travel_connectivity = urban_area['_embedded']['ua:scores']['categories'][4]['score_out_of_10']
    commute = urban_area['_embedded']['ua:scores']['categories'][5]['score_out_of_10']
    business_freedom = urban_area['_embedded']['ua:scores']['categories'][6]['score_out_of_10']
    safety = urban_area['_embedded']['ua:scores']['categories'][7]['score_out_of_10']
    healthcare = urban_area['_embedded']['ua:scores']['categories'][8]['score_out_of_10']
    education = urban_area['_embedded']['ua:scores']['categories'][9]['score_out_of_10']
    environmental_quality = urban_area['_embedded']['ua:scores']['categories'][10]['score_out_of_10']
    economy = urban_area['_embedded']['ua:scores']['categories'][11]['score_out_of_10']
    taxation = urban_area['_embedded']['ua:scores']['categories'][12]['score_out_of_10']
    internet_access = urban_area['_embedded']['ua:scores']['categories'][13]['score_out_of_10']
    leisure_and_culture = urban_area['_embedded']['ua:scores']['categories'][14]['score_out_of_10']
    tolerance = urban_area['_embedded']['ua:scores']['categories'][15]['score_out_of_10']
    outdoors = urban_area['_embedded']['ua:scores']['categories'][16]['score_out_of_10']

    ua = UrbanArea.find_or_create_by(name: urban_area_name, state: urban_area_state)

    UrbanArea.update(ua.id, housing: housing,
                            cost_of_living: cost_of_living,
                            startups: startups,
                            venture_capital: venture_capital,
                            travel_connectivity: travel_connectivity,
                            commute: commute,
                            business_freedom: business_freedom,
                            safety: safety,
                            healthcare: healthcare,
                            education: education,
                            environmental_quality: environmental_quality,
                            economy: economy,
                            taxation: taxation,
                            internet_access: internet_access,
                            leisure_and_culture: leisure_and_culture,
                            tolerance: tolerance,
                            outdoors: outdoors)

    city = City.find_or_create_by(name: city_name, urban_area_id: ua.id)
    City.update(city.id, population: city_population)
    city
  end
end

def display_ua_and_city_data(city)
  ua = UrbanArea.find(city.urban_area_id)
  # binding.pry
  print <<-QOLS
  #{city.name} is a city in the greater urban area of #{ua.name}, #{ua.state}\n  Population: #{city.population}.

  Here are some Quality of Life Metrics for #{ua.name}:
      Housing:                 #{ua.housing.round(2)}
      Cost of Living:          #{ua.cost_of_living.round(2)}
      Startups:                #{ua.startups.round(2)}
      Venture Capital:         #{ua.venture_capital.round(2)}
      Travel Connectivity:     #{ua.travel_connectivity.round(2)}
      Commute:                 #{ua.commute.round(2)}
      Business Freedom:        #{ua.business_freedom.round(2)}
      Safety:                  #{ua.safety.round(2)}
      Healthcare:              #{ua.healthcare.round(2)}
      Education:               #{ua.education.round(2)}
      Environmental Quality:   #{ua.environmental_quality.round(2)}
      Economy:                 #{ua.economy.round(2)}
      Taxation:                #{ua.taxation.round(2)}
      Internet Access:         #{ua.internet_access.round(2)}
      Leisure and Culture:     #{ua.leisure_and_culture.round(2)}
      Tolerance:               #{ua.tolerance.round(2)}
      Outdoors:                #{ua.outdoors.round(2)}

  QOLS
end

def add_to_list?(city)
  loop do
    puts "Would you like to add #{city.name} to your list of potential cities? (Y/N)".green
    input = gets.chomp
    if input.downcase == "y" || input.downcase == "yes"
      return true
    elsif input.downcase == "n" || input.downcase == "no"
      return false
    else
      puts "#{input} is not a valid option.".red
    end
  end
end

#########################LIST#######################

def display_current_list(user)
    puts "\nAlright #{user.name}! Here is your current list of prospective cities:".cyan.underline
     user.get_city_array.each_with_index do |c, index|
       puts "#{index+1}. #{c.name}"
     end
   puts ''
end

def list_menu(user)
  puts "what would you like to do?".blue.underline
  ###Not working yet
  puts "-- view: View your list of cities sorted by a chosen metric."
  puts "-- remove: Remove a city from your list."
  puts "-- delete: Delete your WHOLE list."
  puts "-- compare: Compare your cities based on a metric of your choice."
  puts "-- back: Go back to the main menu."

  loop do
    puts "Please enter an option:".green
    repeat = false
    input = gets.chomp
    case input
    when 'view'
      puts 'Still working on the View feature!'
      repeat = true
    when 'remove'
      remove_from_list_prompt(user)
    when 'delete'
      del = delete_prompt()
      delete_list(user) if del == true
    when 'compare'
      puts "testing compare"
      choose_qol_pref(user)
      repeat = true
    when 'back', 'exit', 'quit'
      puts "\nOkay! Going back to the main menu.".green
    else
      puts "#{input} is not a valid option.".red
      repeat = true
    end
    break if repeat == false
  end
end

def choose_qol_pref(user)
  prompt = TTY::Prompt.new
  qol_array = Qol_string_hash.collect do |k,v|
    v
  end
  input = prompt.select("Choose a Quality of Life Metric by which to sort your list of cities", qol_array )
  metric = Qol_string_hash.key(input)
  user.sort_cities_by_metric(metric)

end

def remove_from_list_prompt(user)
  system('cls')
  user_cities = user.get_city_array
  user_cities.each_with_index do |c, index|
    puts "#{index+1}. #{c.name}"
  end
  exit_loop = false
  loop do
    puts "\nPlease enter the number of the city you would like to remove:\n(type 'quit' to cancel)".green
    input = gets.chomp
    if input.to_i < user_cities.length+1 && input.to_i > 0
      uc = user.find_user_city_by_city_id(user_cities, input)
      UserCity.delete(uc.id)
      puts "\nDeleting #{user_cities[input.to_i-1].name}!\nHeading back to Main Menu.".cyan
      exit_loop = true
      break
    elsif input == 'quit' || input == 'exit'
      exit_loop = true
      break
    else
      puts "#{input} is not a valid option.".red
    end
    break if exit_loop == true
  end
end

def delete_prompt()
  puts "\n!!!!This will delete your WHOLE LIST. For real. Are you sure??".cyan.bold
  loop do
    input = gets.chomp
    if input.downcase == "y" || input.downcase == "yes"
      return true
    elsif input.downcase == "n" || input.downcase == "no"
      return false
    else
      puts "#{input} is not a valid option.".red
    end
  end
end

def delete_list(user)
  UserCity.where(user_id: user.id).delete_all
end

def pref_list(user)

    pref_text = {nil => "N/A",
      0 => "N/A",
      1 => "Not at all important",
      2 => "Slightly important",
      3 => "Somewhat important",
      4 => "Very important",
      5 => "Absolutely Vital!"}
# binding.pry
  print <<-QOLS
            Your Quality of Life Preferences
  Here are your current preferences for our QoL Metrics:
    Housing:                 #{pref_text[user.housing_pref]}
    Cost of Living:          #{pref_text[user.cost_of_living_pref]}
    Startups:                #{pref_text[user.startups_pref]}
    Venture Capital:         #{pref_text[user.venture_capital_pref]}
    Travel Connectivity:     #{pref_text[user.travel_connectivity_pref]}
    Commute:                 #{pref_text[user.commute_pref]}
    Business Freedom:        #{pref_text[user.business_freedom_pref]}
    Safety:                  #{pref_text[user.safety_pref]}
    Healthcare:              #{pref_text[user.healthcare_pref]}
    Education:               #{pref_text[user.education_pref]}
    Environmental Quality:   #{pref_text[user.environmental_quality_pref]}
    Economy:                 #{pref_text[user.economy_pref]}
    Taxation:                #{pref_text[user.taxation_pref]}
    Internet Access:         #{pref_text[user.internet_access_pref]}
    Leisure and Culture:     #{pref_text[user.leisure_and_culture_pref]}
    Tolerance:               #{pref_text[user.tolerance_pref]}
    Outdoors:                #{pref_text[user.outdoors_pref]}

  QOLS
end

def pref_prompt
  input = nil
  puts "What would you like to do?".blue.underline
  puts "-- update: Update your preferences"
  puts "-- back: go back to the main menu"
  puts ""
  loop do
    input = gets.chomp
    if input == 'update'
      break
    elsif input == 'back' || input == 'quit' || input == 'exit'
      break
    else
      puts "#{input} is not a valid option.".red
    end
  end
  return input
end

def pref_update(user)

  puts "For each of the following Quality of Life metrics, please rate\ntheir importance to you personally when deciding on a new place to live".green
  puts ""
  puts "1 is not at all important,and 5 is absolutely critical".green
  puts ""

  Qol_pref_string_hash.each do |k, v|
    exit_loop = false
    loop do
      puts "How important is the metric of #{v} to you, from 1 to 5?".green
      input = gets.chomp
      if input.to_i < 6 && input.to_i > 0
        user.update_pref(k, input)
        break
      elsif input == 'quit' || input == 'exit'
        exit_loop = true
        break
      else
        puts "#{input} is not a valid option.".red
      end
    end
    break if exit_loop == true
  end
  user = User.find_by(name: user.name)
  return user
end


def main_menu(user)

  loop do
    puts ''
    help()
    puts "\nPlease enter an option:".green
    input = gets.chomp
    puts ''
    case input
    when 'find'
      city_query = get_city_input
      city_hash = choose_city(city_query)
      city = get_city_from_api(city_hash) unless city_hash.nil?
      if city != nil
        display_ua_and_city_data(city)
        if add_to_list?(city) == true
          puts "Adding #{city.name} to your list.\n".cyan
          user.add_city_to_list(city)
        else
          puts "Okay, no problem! Returning to the main menu now.\n".cyan
        end
      end
    when 'list'
      if user.get_city_array.length<1
        puts "you have no cities in your list! :(\nLet's go back and add some.".cyan
      else
        display_current_list(user)
        list_input = list_menu(user)
      end
    when 'preferences'
      pref_list(user)
      input = pref_prompt()
      user = pref_update(user) if input == 'update'
      puts ""
    when 'help'
      help()
    when 'exit', 'quit'
      puts 'Goodbye!'.green.bold
      break
    else
      puts "#{input} is not a valid option.".red
    end
  end
end

def run
  welcome
  name = get_name()
  puts ''
  existing_user = look_for_user(name)
  if !existing_user.nil?
    user = existing_user
    puts "Welcome back, #{name}!".bold.green
  else
    user = new_user(name)
    puts "Hello, #{name}! Welcome to City Quality of Life (CQL)!".bold.green
  end
  main_menu(user)
end
