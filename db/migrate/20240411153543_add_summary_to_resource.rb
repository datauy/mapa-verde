class AddSummaryToResource < ActiveRecord::Migration[7.1]
  def change
    add_column :resources, :summary, :text
  end
end
