class RenameColumnFromHeightToLengthInPropertiesTable < ActiveRecord::Migration
  def change
    rename_column :properties, :height, :length
  end
end
