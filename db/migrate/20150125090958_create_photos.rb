class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :image_name
      t.integer :imageable_id
      t.string :imageable_type
      t.integer :pos, default: 0

      t.timestamps null: false
    end

    add_index :photos, :imageable_id
  end
end
