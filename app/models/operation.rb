class Operation < ApplicationRecord
    has_one_attached :icon

    has_many :operation_relations
    #has_many :organiaztions, through: :operation_relations
end
