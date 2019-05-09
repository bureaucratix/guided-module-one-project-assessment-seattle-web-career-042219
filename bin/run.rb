require_relative '../config/environment'

###### Uncomment these two lines to remove the #####
###### wordy SQL logs ActiveRecord spits out #######
old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil
####################################################

run()
#
#
# user1 = User.create(name:"alex")
# user1.update(cost_of_living_pref: 3, education_pref: 4, internet_access_pref: 1, outdoors_pref: 2, travel_connectivity_pref: 5)
# pref_list(user1)
