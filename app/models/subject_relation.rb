class SubjectRelation < ApplicationRecord
  belongs_to :subject
  belongs_to :organization, optional: true
  belongs_to :activity, optional: true
end
