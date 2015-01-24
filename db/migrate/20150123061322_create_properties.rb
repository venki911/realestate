class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :code_ref
      t.string :verification_status
      t.string :status
      t.string :swot
      t.text :note
      t.string :borey_name
      
      t.references :category, index: true
      t.references :province, index: true
      t.references :district, index: true
      t.references :commune, index: true
      t.references :user, index: true

      t.string :type_of
      t.float :width
      t.float :height
      t.float :area
      t.string :unit
      t.string :main_photo
      t.string :reject_reason
      
      t.timestamps null: false
    end

    add_foreign_key :properties, :categories
    add_foreign_key :properties, :provinces
    add_foreign_key :properties, :districts
    add_foreign_key :properties, :communes
    add_foreign_key :properties, :users
  end
end
