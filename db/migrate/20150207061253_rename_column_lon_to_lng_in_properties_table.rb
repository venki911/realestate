class RenameColumnLonToLngInPropertiesTable < ActiveRecord::Migration
  def change
    rename_column :properties, :lon, :lng
  end
end
