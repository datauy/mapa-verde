class AddEnabledToOrganization < ActiveRecord::Migration[7.1]
  def change
    add_column :organizations, :enabled, :boolean
  end
end
