class AddParentZone < ActiveRecord::Migration[7.1]
  def change
    add_reference :zones, :parent_zone, foreign_key: { to_table: :zones }
  end
end
