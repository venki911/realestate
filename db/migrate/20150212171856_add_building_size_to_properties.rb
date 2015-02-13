class AddBuildingSizeToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :building_width, :float
    add_column :properties, :building_length, :float
    add_column :properties, :building_area, :float
    add_column :properties, :building_unit, :string
  end
end
