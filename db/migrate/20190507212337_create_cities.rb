class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
    t.string :name
    t.string :state
    t.integer :population
    t.integer :cost_of_living
    t.integer :education
  end
  end
end
