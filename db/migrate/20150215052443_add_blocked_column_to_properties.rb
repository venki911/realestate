class AddBlockedColumnToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :mark_as_blocked, :boolean, default: false
  end
end
