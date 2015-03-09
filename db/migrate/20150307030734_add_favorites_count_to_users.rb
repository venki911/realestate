class AddFavoritesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :favorites_count, :integer, default: 0
  end
end
