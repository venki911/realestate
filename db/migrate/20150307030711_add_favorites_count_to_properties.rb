class AddFavoritesCountToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :favorites_count, :integer, default: 0
  end
end
