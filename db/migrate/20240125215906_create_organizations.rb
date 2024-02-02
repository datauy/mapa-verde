class CreateOrganizations < ActiveRecord::Migration[7.1]
  def change
    create_table :organizations do |t|
      t.string :name
      t.integer :otype
      t.references :subject, null: false, foreign_key: true
      t.text :description
      t.string :website
      t.string :phone
      t.string :whatsapp
      t.string :email
      t.string :instagram
      t.string :tiktok
      t.string :twitter
      t.string :facebook
      t.string :snapchat
      t.string :other_network
      t.string :address
      t.integer :region
      t.text :volunteers_description
      t.string :volunteers_url
      t.string :donations

      t.timestamps
    end
  end
end
