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

  #Validations
  validates :name, presence: true
  validates :email, presence: true
  validates :zones, presence: true
  validates :description, presence: true
  validates :organization_type, presence: true
  validates :subject, presence: true

  after_create do
    begin
      SysMailer.with(organization: self).new_organization.deliver
    rescue StandardError => e
      loger.info("\n\nERROR IN SENDMAIL\n#{e.inspect}")
    end
  end
end
