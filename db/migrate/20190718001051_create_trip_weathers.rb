class CreateTripWeathers < ActiveRecord::Migration[5.2]
  def change
    create_table :trip_weathers do |t|
      t.integer :time
      t.string :summary
      t.string :icon
      t.float :temperature
      t.float :precipProbability
      t.float :precipIntensity
      t.float :windSpeed
      t.float :windGust
      t.integer :windBearing
      t.references :trip, foreign_key: true

      t.timestamps
    end
  end
end
