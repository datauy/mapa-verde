class Zone < ApplicationRecord
    belongs_to :parent_zone, class_name: 'Zone', optional: true

    has_many :zone_relations
    #has_many :organiaztions, through: :zone_relations 

    enum ztype: [
        'País',
        'Departamento',
        'Ciudad',
        'Localidad'
    ]

    def children
        Zone.where(parent_zone: self.id)
    end
end
