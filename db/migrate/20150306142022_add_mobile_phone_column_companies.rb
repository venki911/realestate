class AddMobilePhoneColumnCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :mobile_phone, :string
  end
end
