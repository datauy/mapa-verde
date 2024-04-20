class ApplicationMailer < ActionMailer::Base
  default from: 'no-responder@data.org.uy', host: 'mapa-verde.stage.data.org.uy'
  layout "mailer"
end
