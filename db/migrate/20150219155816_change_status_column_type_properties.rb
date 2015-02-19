class ChangeStatusColumnTypeProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :status, :string
    add_column :properties, :status, :boolean, default: true
  end
end
