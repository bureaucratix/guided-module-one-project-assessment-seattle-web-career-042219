# welcome
#
# get name and (potentially current city)
#   --- check DB to see if name exists, pull profile, or create one
#
# prompt of options for CRUD operations
#   -- check a city by name ((for later: let them add state and parse that out))
#       ((--check duplicate names, choose which city))
#       -- after spitting out values, prompt to add to list
#       -- back to main
#   -- check my list of cities
#     -- compare side by side ((filter, sort, etc))
#     -- delete cities
#     -- look for more cities to add
#     -- delete the whole darn list
#     -- back to main
#   -- (( preferences update stuff))
#     -- (())
#   -- help: display the options
#   -- quit

def welcome
  puts "Welcome to [appname]! What's your username?"
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
  puts 'Here are the things you can do:'
  puts '-- lookup: Look up a city / add it to your list!'
  puts '-- list: View your current list of cities'
  puts '-- preferences: [[UNDER CONSTRUCTION]]'
  puts '-- help: Display these options'
  puts '-- exit: Exit the application'
end

def get_city_input
  puts 'Enter the name of a city'
  gets.chomp
end

#takes city name and shows list to choose one city
def choose_city(city_query)
  response_string = RestClient.get("https://api.teleport.org/api/cities/?search=#{city_query}&embed=city%3Asearch-results%2Fcity%3Aitem%2Fcity%3Aurban_area%2Fua%3Ascores")
  response_hash = JSON.parse(response_string)
  if response_hash['_embedded']['city:search-results'].empty?
    puts "No matches found!
    \nBringing you back to the main menu!\n "
    return nil
  elsif response_hash['_embedded']['city:search-results'].length == 1
    return response_hash['_embedded']['city:search-results'][0]
  else
    puts ''
    response_hash['_embedded']['city:search-results'].each_with_index do |city_hash, index|
      puts "#{index + 1}. #{city_hash['_embedded']['city:item']['full_name']}"
    end
    puts ''
    puts 'Please enter the number of the city you would like to view.'
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
    puts "Sorry, this city does not belong to an urban area with Quality of Life data! :( \nBringing you back to the main menu!\n "
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
  print <<-QOLS
  #{city.name} is a city in the greater urban area of
  #{ua.name}, #{ua.state}.

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
    puts "Would you like to add #{city.name} to your list of potential cities? (Y/N)"
    input = gets.chomp
    if input.downcase == "y" || input.downcase == "yes"
      return true
    elsif input.downcase == "n" || input.downcase == "no"
      return false
    else
      puts "I didn't get that-- please enter a valid response"
    end
  end
end

def display_current_list(user)
end

def pref_list(user)

    pref_text = {nil => "N/A",
      0 => "N/A",
      1 => "Not at all important",
      2 => "Slightly important",
      3 => "Somewhat important",
      4 => "Very important",
      5 => "Absolutely Vital!"}

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

def main_menu(user)
  puts
  help
  loop do
    puts 'Please enter an option:'
    input = gets.chomp
    puts
    case input
    when 'lookup'
      city_query = get_city_input
      city_hash = choose_city(city_query)
      city = get_city_from_api(city_hash) unless city_hash.nil?
      if city != nil
        display_ua_and_city_data(city)
        binding.pry
        if add_to_list?(city) == true
          puts "Adding #{city.name} to your list."
          user.add_city_to_list(city)
        else
          puts "Okay, no problem! Returning to the main menu now."
        end
      end
    when 'list'
      puts 'test'
    when 'preferences'
      pref_list(user)
    when 'help'
      help
    when 'exit', 'quit'
      puts 'Goodbye!'
      break
    else
      puts "#{input} is not a valid option."
      help
    end
  end
end

def run
  welcome
  name = get_name
  existing_user = look_for_user(name)
  if !existing_user.nil?
    user = existing_user
    puts "Welcome back #{name}!"
  else
    user = new_user(name)
    puts "Hello #{name}! Welcome to [appname]!"
  end
  main_menu(user)
end
