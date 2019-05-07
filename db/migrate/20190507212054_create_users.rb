class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
    t.string :name
    t.integer :cost_of_living_preference
    t.integer :education_preference
  end
  end
end
