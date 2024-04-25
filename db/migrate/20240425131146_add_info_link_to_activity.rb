class AddInfoLinkToActivity < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :info_link, :string
  end
end
