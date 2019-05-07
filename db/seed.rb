# user1 = User.create(name: Faker::Name.name, cost_of_living_preference: 3, education_preference: 2)
# 
# user2 = User.create(name: Faker::Name.name, cost_of_living_preference: 2, education_preference: 3)
#
# user3 = User.create(name: Faker::Name.name, cost_of_living_preference: 2, education_preference: 1)
#
# user4 = User.create(name: Faker::Name.name, cost_of_living_preference: 3, education_preference: 2)
#
# lynnwood = City.create(name: "Lynnwood", state: "WA", population:"30000", cost_of_living: 5, education: 2)
#
# tacoma = City.create(name: "Tacoma", state: "WA", population:"56000", cost_of_living: 4, education: 6)
#
# user1.add_city_to_list(tacoma)
# user1.add_city_to_list(lynnwood)
# user3.add_city_to_list(tacoma)
# user4.add_city_to_list(lynnwood)
# user2.add_city_to_list(lynnwood)
#
