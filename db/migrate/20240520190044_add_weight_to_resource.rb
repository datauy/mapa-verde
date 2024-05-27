class AddWeightToResource < ActiveRecord::Migration[7.1]
  def change
    add_column :resources, :weight, :integer
  end
end
