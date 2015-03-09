class RenamePhoneToOfficePhoneCompanies < ActiveRecord::Migration
  def change
    rename_column :companies, :phone, :office_phone
  end
end
