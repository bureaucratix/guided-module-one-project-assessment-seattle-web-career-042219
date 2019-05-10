class City < ActiveRecord::Base
  has_many :user_cities
  has_many :users, through: :user_cities
  belongs_to :urban_area

  def display_ua_and_city_data
    ua = UrbanArea.find(self.urban_area_id)
    # binding.pry
    print <<-QOLS
    #{self.name} is a city in the greater urban area of #{ua.name}, #{ua.state}\n  Population: #{self.population}.

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

end
