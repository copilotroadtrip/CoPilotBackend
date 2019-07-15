class ChangeAreasToStringInPois < ActiveRecord::Migration[5.2]
  def change
    change_column :pois, :land_area, :string
    change_column :pois, :total_area, :string
  end
end
