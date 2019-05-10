class User < ActiveRecord::Base
  has_many :user_cities
  has_many :cities, through: :user_cities

  def add_city_to_list(city)
    UserCity.find_or_create_by(user_id: id, city_id: city.id)
  end

  def update_pref(preference_name, new_value)
    User.update(id, preference_name => new_value.to_i)
  end

  def get_city_array
    City.left_outer_joins(:user_cities).where('user_cities.user_id = ?', id)
  end

  def find_user_city_by_city_id(city_array, city_index)
    UserCity.find_by(user_id: id, city_id: city_array[city_index.to_i - 1].id)
  end

  def display_current_list
    puts "\nAlright #{name}! Here is your current list of prospective cities:".cyan.underline
    get_city_array.each_with_index do |c, index|
      puts "#{index + 1}. #{c.name}"
    end
    puts ''
  end

  def sort_cities_by_metric(metric)
    table = TTY::Table.new header: ['City', 'Urban Area', Qol_string_hash[metric]]
    get_city_array.each do |city|
      table << [city.name, UrbanArea.find(city.urban_area_id).name, UrbanArea.find(city.urban_area_id)[metric].round(2)]
    end
    puts table.render :ascii, alignment: [:left]
  end

  def choose_qol_pref
    prompt = TTY::Prompt.new
    qol_array = Qol_string_hash.collect do |_k, v|
      v
    end
    input = prompt.select("\nChoose a Quality of Life Metric by which to sort your list of cities", qol_array)
    metric = Qol_string_hash.key(input)
    sort_cities_by_metric(metric)
  end

  def remove_from_list_prompt
    system('cls')
    user_cities = get_city_array
    user_cities.each_with_index do |c, index|
      puts "#{index + 1}. #{c.name}"
    end
    exit_loop = false
    loop do
      puts "\nPlease enter the number of the city you would like to remove:\n(type 'quit' to cancel)".green
      input = gets.chomp
      if input.to_i < user_cities.length + 1 && input.to_i > 0
        uc = find_user_city_by_city_id(user_cities, input)
        UserCity.delete(uc.id)
        puts "\nDeleting #{user_cities[input.to_i - 1].name}!\nHeading back to Main Menu.".cyan
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

  def delete_list
    UserCity.where(user_id: id).delete_all
  end

  def pref_list
    pref_text = { nil => 'N/A',
                  0 => 'N/A',
                  1 => 'Not at all important',
                  2 => 'Slightly important',
                  3 => 'Somewhat important',
                  4 => 'Very important',
                  5 => 'Absolutely Vital!' }
    print <<-QOLS
              Your Quality of Life Preferences
    Here are your current preferences for our QoL Metrics:
      Housing:                 #{pref_text[housing_pref]}
      Cost of Living:          #{pref_text[cost_of_living_pref]}
      Startups:                #{pref_text[startups_pref]}
      Venture Capital:         #{pref_text[venture_capital_pref]}
      Travel Connectivity:     #{pref_text[travel_connectivity_pref]}
      Commute:                 #{pref_text[commute_pref]}
      Business Freedom:        #{pref_text[business_freedom_pref]}
      Safety:                  #{pref_text[safety_pref]}
      Healthcare:              #{pref_text[healthcare_pref]}
      Education:               #{pref_text[education_pref]}
      Environmental Quality:   #{pref_text[environmental_quality_pref]}
      Economy:                 #{pref_text[economy_pref]}
      Taxation:                #{pref_text[taxation_pref]}
      Internet Access:         #{pref_text[internet_access_pref]}
      Leisure and Culture:     #{pref_text[leisure_and_culture_pref]}
      Tolerance:               #{pref_text[tolerance_pref]}
      Outdoors:                #{pref_text[outdoors_pref]}

    QOLS
  end

  def pref_update
    puts "For each of the following Quality of Life metrics, please rate\ntheir importance to you personally when deciding on a new place to live".green
    puts ''
    puts '1 is not at all important,and 5 is absolutely critical'.green
    puts ''

    Qol_pref_string_hash.each do |k, v|
      exit_loop = false
      loop do
        puts "How important is the metric of #{v} to you, from 1 to 5?".green
        input = gets.chomp
        if input.to_i < 6 && input.to_i > 0
          update_pref(k, input)
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
    user = User.find_by(name: name)
    user
  end
end
