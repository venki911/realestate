class AddColumnLatLonToPropertiesTable < ActiveRecord::Migration
  def change
    add_column :properties, :lat, :float
    add_column :properties, :lon, :float
  end
end
