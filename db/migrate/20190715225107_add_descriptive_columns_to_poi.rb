class AddDescriptiveColumnsToPoi < ActiveRecord::Migration[5.2]
  def change
    add_column :pois, :population, :integer
    add_column :pois, :state, :string
    add_column :pois, :land_area, :integer
    add_column :pois, :total_area, :integer
  end
end
