class AddColumnIsLandToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :is_land, :boolean, default: false
  end
end
