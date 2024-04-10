class AddStateLocationToActivity < ActiveRecord::Migration[7.1]
  def change
    add_reference :activities, :location, foreign_key: { to_table: :zones }
    add_reference :activities, :state, foreign_key: { to_table: :zones }
  end
end
