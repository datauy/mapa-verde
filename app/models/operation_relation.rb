class OperationRelation < ApplicationRecord
  belongs_to :operation
  belongs_to :organization, optional: true
  belongs_to :activity, optional: true
end
