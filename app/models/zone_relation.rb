class ZoneRelation < ApplicationRecord
  belongs_to :zone
  belongs_to :organization, optional: true
  belongs_to :activity, optional: true
end
