class AddStateLocationToOrganization < ActiveRecord::Migration[7.1]
  def change
    add_reference :organizations, :state, foreign_key: { to_table: :zones }
    add_reference :organizations, :location, foreign_key: { to_table: :zones }
  end
end
