class CreateOrganizationTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_types do |t|
      t.text :name

      t.timestamps
    end
  end
end
