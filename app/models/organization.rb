class Organization < ApplicationRecord
  has_one_attached :logo

  belongs_to :subject

  belongs_to :state, class_name: "Zone"
  belongs_to :location, class_name: "Zone"

  has_many :subject_relations
  has_many :subjects, through: :subject_relations

  has_many :operation_relations
  has_many :operations, through: :operation_relations

  has_many :zone_relations
  has_many :zones, through: :zone_relations

  has_many :activity_organizations
  has_many :activities, through: :activity_organizations

  belongs_to :organization_type

  enum region: [
    'Región Centro',
		'Región Este',
		'Región Litoral Norte',
		'Región Litoral Sur',
		'Región Metropolitana',
		'Región Noreste'
  ]
end
