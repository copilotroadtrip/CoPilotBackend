class CreateTripPois < ActiveRecord::Migration[5.2]
  def change
    create_table :trip_pois do |t|
      t.references :trip, foreign_key: true
      t.references :poi, foreign_key: true
      t.integer :sequence_number

      t.timestamps
    end
  end
end
