class User < ActiveRecord::Base
  has_many :user_cities
  has_many :cities, through: :user_cities

end
