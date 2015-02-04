class AddColumnFeaturesToPropertiesTable < ActiveRecord::Migration
  def change
    add_column :properties, :config_features, :hstore
    add_column :properties, :config_equipments, :hstore
    add_column :properties, :config_services, :hstore
  end
end
