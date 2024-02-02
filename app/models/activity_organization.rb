class ActivityOrganization < ApplicationRecord
  belongs_to :organization
  belongs_to :activity
end
