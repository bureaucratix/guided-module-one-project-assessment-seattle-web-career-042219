class CreateUrbanAreas < ActiveRecord::Migration[5.2]
  def change
    create_table :urban_areas do |t|
      t.string :name
      t.string :state
      t.float :housing
      t.float :cost_of_living
      t.float :startups
      t.float :venture_capital
      t.float :travel_connectivity
      t.float :commute
      t.float :business_freedom
      t.float :safety
      t.float :healthcare
      t.float :education
      t.float :environmental_quality
      t.float :economy
      t.float :taxation
      t.float :internet_access
      t.float :leisure_and_culture
      t.float :tolerance
      t.float :outdoors
    end
  end
end
