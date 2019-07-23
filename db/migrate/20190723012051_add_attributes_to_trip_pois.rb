class AddAttributesToTripPois < ActiveRecord::Migration[5.2]
  def change
    add_column :trip_pois, :population, :integer
    add_column :trip_pois, :state, :string
    add_column :trip_pois, :name, :string
    add_column :trip_pois, :lat, :float
    add_column :trip_pois, :lng, :float
    add_column :trip_pois, :time_to_poi, :float
  end
end
