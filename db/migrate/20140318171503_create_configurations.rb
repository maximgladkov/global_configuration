class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations, id: false, primary_key: :key, force: true do |t|
      t.string :key
      t.boolean :data_boolean
      t.integer :data_integer
      t.float :data_float
      t.string :data_string
    end
  end
end
