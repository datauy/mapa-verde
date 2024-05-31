class Resource < ApplicationRecord
    after_validation :set_slug, only: [:create, :update]
    private
    def set_slug
        self.slug = title.to_s.parameterize
    end
    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "description", "id", "id_value", "link", "title", "updated_at", "summary", 'weight', 'slug']
    end
    has_many :subject_relations
    has_many :subjects, through: :subject_relations
end
