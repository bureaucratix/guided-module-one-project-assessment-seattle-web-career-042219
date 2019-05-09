class User < ActiveRecord::Base
  has_many :user_cities
  has_many :cities, through: :user_cities

 def add_city_to_list(city)
  UserCity.find_or_create_by(user_id: self.id, city_id: city.id)
 end

 def update_pref(preference_name, new_value)
  User.update(self.id, preference_name => new_value.to_i)
 end

 def get_city_array
   City.left_outer_joins(:user_cities).where('user_cities.user_id = ?', self.id)

 end

  def find_user_city_by_city_id(city_array, city_index)
    UserCity.find_by(user_id: self.id, city_id: city_array[city_index.to_i-1].id)
  end

  def sort_cities_by_metric(metric)
    table = TTY::Table.new header: ['City', 'Urban Area', Qol_string_hash[metric]]
    self.get_city_array.each do |city|
      table << [city.name, UrbanArea.find(city.urban_area_id).name, UrbanArea.find(city.urban_area_id)[metric].round(2)]
    end
    puts table.render :ascii, alignment: [:left]
  end

end
