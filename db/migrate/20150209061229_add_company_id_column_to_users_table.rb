class AddCompanyIdColumnToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :company_id, :integer
  end
end
