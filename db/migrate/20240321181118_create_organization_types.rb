class CreateOrganizationTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
