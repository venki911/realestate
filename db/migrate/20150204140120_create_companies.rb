class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :license
      t.integer :year_founded
      t.string :phone
      t.string :email
      t.string :website
      t.string :logo
      t.float :lat
      t.float :lng
      t.text :summary

      t.timestamps null: false
    end
  end
end
