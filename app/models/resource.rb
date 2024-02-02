class Resource < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "description", "id", "id_value", "link", "title", "updated_at"]
    end
end
