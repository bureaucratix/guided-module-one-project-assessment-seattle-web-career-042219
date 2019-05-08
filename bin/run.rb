require_relative '../config/environment'

puts "hello world"


def get_city_from_api(city_query)
  response_string = RestClient.get("https://api.teleport.org/api/cities/?search=#{city_query}&embed=city%3Asearch-results%2Fcity%3Aitem%2Fcity%3Aurban_area%2Fua%3Ascores")
  response_hash = JSON.parse(response_string)
  city_hash = response_hash["_embedded"]["city:search-results"][0]
  city_name = city_hash["_embedded"]["city:item"]["name"]
  city_population = city_hash["_embedded"]["city:item"]["population"]
  city_state = city_hash["_embedded"]["city:item"]["full_name"].split(", ")[1]
  urban_area = city_hash["_embedded"]["city:item"]["_embedded"]["city:urban_area"]
  urban_area_name = urban_area["name"]
  housing = urban_area["_embedded"]["ua:scores"]["categories"][0]["score_out_of_10"]
  cost_of_living = urban_area["_embedded"]["ua:scores"]["categories"][1]["score_out_of_10"]
  startups = urban_area["_embedded"]["ua:scores"]["categories"][2]["score_out_of_10"]
  venture_capital = urban_area["_embedded"]["ua:scores"]["categories"][3]["score_out_of_10"]
  travel_connectivity = urban_area["_embedded"]["ua:scores"]["categories"][4]["score_out_of_10"]
  commute = urban_area["_embedded"]["ua:scores"]["categories"][5]["score_out_of_10"]
  business_freedom = urban_area["_embedded"]["ua:scores"]["categories"][6]["score_out_of_10"]
  safety = urban_area["_embedded"]["ua:scores"]["categories"][7]["score_out_of_10"]
  healthcare = urban_area["_embedded"]["ua:scores"]["categories"][8]["score_out_of_10"]
  education = urban_area["_embedded"]["ua:scores"]["categories"][9]["score_out_of_10"]
  environmental_quality = urban_area["_embedded"]["ua:scores"]["categories"][10]["score_out_of_10"]
  economy = urban_area["_embedded"]["ua:scores"]["categories"][11]["score_out_of_10"]
  taxation = urban_area["_embedded"]["ua:scores"]["categories"][12]["score_out_of_10"]
  internet_access = urban_area["_embedded"]["ua:scores"]["categories"][13]["score_out_of_10"]
  leisure_and_culture = urban_area["_embedded"]["ua:scores"]["categories"][14]["score_out_of_10"]
  tolerance = urban_area["_embedded"]["ua:scores"]["categories"][15]["score_out_of_10"]
  outdoors = urban_area["_embedded"]["ua:scores"]["categories"][16]["score_out_of_10"]
end
