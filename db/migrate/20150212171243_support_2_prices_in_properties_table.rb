class Support2PricesInPropertiesTable < ActiveRecord::Migration
  def change
    rename_column :properties, :total_price, :total_price_rent
    rename_column :properties, :price_per_unit, :price_per_unit_rent
    rename_column :properties, :price_per_size, :price_per_size_rent
    rename_column :properties, :price_per_duration, :price_per_duration_rent

    add_column :properties, :total_price_sale, :float
    add_column :properties, :price_per_unit_sale, :float
    add_column :properties, :price_per_size_sale, :string
  end
end
