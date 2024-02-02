class CreateZoneRelations < ActiveRecord::Migration[7.1]
  def change
    create_table :zone_relations do |t|
      t.references :zone, null: false, foreign_key: true
      t.references :organization, foreign_key: true
      t.references :activity, foreign_key: true

      t.timestamps
    end
  end
end
