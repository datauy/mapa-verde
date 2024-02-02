class CreateActivityOrganizations < ActiveRecord::Migration[7.1]
  def change
    create_table :activity_organizations do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
