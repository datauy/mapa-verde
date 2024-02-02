class CreateOperations < ActiveRecord::Migration[7.1]
  def change
    create_table :operations do |t|
      t.string :name

      t.timestamps
    end
  end
end
