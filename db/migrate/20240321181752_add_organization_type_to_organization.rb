class AddOrganizationTypeToOrganization < ActiveRecord::Migration[7.1]
  def change
    add_reference :organizations, :organization_type, null: false, foreign_key: true, default: 1
  end
end
