# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

#Rails.application.config.session_store :cookie_store, key: "_my_name_#{Rails.env}", expire_after: 1.year, domain: :all