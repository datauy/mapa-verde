class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.string :title
      t.text :description
      t.string :address
      t.datetime :starts
      t.datetime :ends

      t.timestamps
    end
  end
end
