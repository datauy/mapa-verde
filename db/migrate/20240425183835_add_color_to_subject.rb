class AddColorToSubject < ActiveRecord::Migration[7.1]
  def change
    add_column :subjects, :color, :string
  end
end
