class AddPhotoCountToPropertiesTable < ActiveRecord::Migration
  def change
    add_column :properties, :photos_count, :integer, default: 0
  end
end
