class Organization < ApplicationRecord
  has_one_attached :logo
  
  belongs_to :subject

  has_many :subject_relations
  has_many :subjects, through: :subject_relations

  has_many :operation_relations
  has_many :operations, through: :operation_relations

  has_many :zone_relations
  has_many :zones, through: :zone_relations

  enum region: [
    'Región Centro',      
		'Región Este',
		'Región Litoral Norte',      
		'Región Litoral Sur',
		'Región Metropolitana',
		'Región Noreste'
  ]

  enum otype: [
    'Tipo 1 (federada)',
    'Tipo 2',
    'Tipo 3'
  ]
end
