class AddOtherResponsiblesToActivity < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :other_responsibles, :string
  end
end
