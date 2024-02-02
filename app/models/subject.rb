class Subject < ApplicationRecord
    has_one_attached :icon

    has_many :subject_relations
    has_many :organization, through: :subject_relations
end
