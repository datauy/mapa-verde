class Subject < ApplicationRecord
    has_one_attached :icon

    has_many :subject_relations
    has_many :organization, through: :subject_relations

    def icon_url
        this.icon.present? ? url_for(this.icon) : ''
    end
end
