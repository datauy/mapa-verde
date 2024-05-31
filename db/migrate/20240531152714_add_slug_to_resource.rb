class AddSlugToResource < ActiveRecord::Migration[7.1]
  def change
    add_column :resources, :slug, :string
  end
end
