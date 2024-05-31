class AddSlugToActivity < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :slug, :string
  end
end
