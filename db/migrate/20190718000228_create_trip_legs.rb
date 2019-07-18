class CreateTripLegs < ActiveRecord::Migration[5.2]
  def change
    create_table :trip_legs do |t|
      t.references :trip, foreign_key: true
      t.integer :distance, limit: 8
      t.float :duration
      t.integer :sequence_number

      t.timestamps
    end
  end
end
