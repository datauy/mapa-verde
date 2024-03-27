class AddSubjectToActivity < ActiveRecord::Migration[7.1]
  def change
    add_reference :activities, :subject, null: false, foreign_key: true, default: 1
  end
end
