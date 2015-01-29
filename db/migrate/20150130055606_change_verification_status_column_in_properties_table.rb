class ChangeVerificationStatusColumnInPropertiesTable < ActiveRecord::Migration
  def up
    change_column :properties, :verification_status, :string, default: Property::VERIFICATION_STUTUS_PENDING
  end

  def down
    #just a hack to rollback. the change method does not know how to handle this.
  end
end
