class AddShowOnMapColumnToPropertiesTable < ActiveRecord::Migration
  def change
    add_column :properties, :show_on_map, :boolean, default: true
  end
end
