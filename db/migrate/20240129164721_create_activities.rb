class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.string :title
      t.text :description
      t.string :address
      t.integer :state
      t.integer :municipality
      t.time :start
      t.time :end

      t.timestamps
    end
  end
end
