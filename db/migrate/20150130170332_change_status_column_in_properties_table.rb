class ChangeStatusColumnInPropertiesTable < ActiveRecord::Migration
  def up
    change_column :properties, :status, :string, default: Property::STATUS_AVAILABLE
  end

  def down

  end
end
