require_relative '../config/environment'

###### Uncomment these two lines to remove the #####
###### wordy SQL logs ActiveRecord spits out #######
old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil
####################################################

run()
