class AddPriceColumnToPropertiesTable < ActiveRecord::Migration
  def change
    add_column :properties, :total_price, :float
    add_column :properties, :price_per_unit, :float
    add_column :properties, :price_per_size, :string
    add_column :properties, :price_per_duration, :string
  end
end
