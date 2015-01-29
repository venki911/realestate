class AddPropertiesCountColumnToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :properties_count, :integer, default: 0
  end
end
