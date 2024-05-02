class ApplicationMailer < ActionMailer::Base
  default from: 'no-responder@data.org.uy', host: 'mail.data.org.uy'
  layout "mailer"
end
