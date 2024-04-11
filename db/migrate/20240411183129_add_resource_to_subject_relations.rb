class AddResourceToSubjectRelations < ActiveRecord::Migration[7.1]
  def change
    add_reference :subject_relations, :resource, foreign_key: true
  end
end
