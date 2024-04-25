class Activity < ApplicationRecord
    has_one_attached :image

    has_many :activity_organizations, dependent: :delete_all
    has_many :organizations, through: :activity_organizations

    has_many :subject_relations, dependent: :delete_all
    has_many :subjects, through: :subject_relations

    has_many :operation_relations, dependent: :delete_all
    has_many :operations, through: :operation_relations

    #has_many :zone_relations, dependent: :delete_all
    #has_many :zones, through: :zone_relations

    belongs_to :state, class_name: "Zone", optional: true
    belongs_to :location, class_name: "Zone", optional: true

    after_create do
        SysMailer.with(activity: self).new_activity.deliver
    end
end
