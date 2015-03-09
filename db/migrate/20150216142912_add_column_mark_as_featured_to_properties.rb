class AddColumnMarkAsFeaturedToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :mark_as_featured, :boolean, default: false
  end
end
