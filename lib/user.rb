class User < ActiveRecord::Base
  has_many :user_cities
  has_many :cities, through: :user_cities

 def add_city_to_list(city)
  UserCity.create(user_id: self.id, city_id: city.id)
 end

 def update_pref(preference_name, new_value)
  User.update(self.id, preference_name => new_value.to_i)
 end

end
