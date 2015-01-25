class AddRoleToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, defalt: User::ROLE_INDIVIDUAL
  end
end
