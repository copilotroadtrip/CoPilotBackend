class AddStepsToTrips < ActiveRecord::Migration[5.2]
  def change
    add_column :trips, :steps, :json
  end
end
