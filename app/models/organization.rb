class Organization < ApplicationRecord
  has_one_attached :logo

  belongs_to :subject

  has_one :state, class_name: "Zone"
  has_one :location, class_name: "Zone"

  has_many :subject_relations, dependent: :delete_all
  has_many :subjects, through: :subject_relations

  has_many :operation_relations, dependent: :delete_all
  has_many :operations, through: :operation_relations

  has_many :zone_relations, dependent: :delete_all
  has_many :zones, through: :zone_relations

  has_many :activity_organizations, dependent: :delete_all
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
  after_create do
    SysMailer.with(organization: self).new_organization.deliver
  end
end
