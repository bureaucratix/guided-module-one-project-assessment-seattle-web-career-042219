class UpdatePreferencesForUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :housing_pref, :integer
    add_column :users, :cost_of_living_pref, :integer
    add_column :users, :startups_pref, :integer
    add_column :users, :venture_captial_pref, :integer
    add_column :users, :travel_connectivity_pref, :integer
    add_column :users, :commute_pref, :integer
    add_column :users, :business_freedom_pref, :integer
    add_column :users, :safety_pref, :integer
    add_column :users, :healthcare_pref, :integer
    add_column :users, :education_pref, :integer
    add_column :users, :environmental_quality_pref, :integer
    add_column :users, :economy_pref, :integer
    add_column :users, :taxation_pref, :integer
    add_column :users, :internet_access_pref, :integer
    add_column :users, :leisure_and_culture_pref, :integer
    add_column :users, :tolerance_pref, :integer
    add_column :users, :outdoors, :integer
  end
end
