class RemovePoiIdFromTripPois < ActiveRecord::Migration[5.2]
  def change
    remove_column :trip_pois, :poi_id

  end
end
