class AddMarkAsColumnToPropertiesTable < ActiveRecord::Migration
  def change
    add_column :properties, :mark_as_urgent, :boolean, default: false
    add_column :properties, :mark_as_exclusive, :boolean, default: false
  end
end
