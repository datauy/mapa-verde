Recaptcha.configure do |config|
  config.site_key = Rails.application.credentials.recaptcha.sitekey
  config.secret_key = Rails.application.credentials.recaptcha.sitesecret
end
