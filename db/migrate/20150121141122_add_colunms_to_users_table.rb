class AddColunmsToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :user_name, :string
    add_column :users, :fb_id, :string
    add_column :users, :lat, :float
    add_column :users, :lon, :float
    add_column :users, :last_signed_in_at, :datetime
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_token_at, :datetime
    add_column :users, :type, :string
    add_column :users, :gender, :string
    add_column :users, :avatar, :string
    add_column :users, :sign_up_step, :integer, default: 0
  end
end
