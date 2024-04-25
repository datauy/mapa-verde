class SysMailer < ApplicationMailer
  def new_organization
    @organization = params[:organization]
    @url  =  admin_organization_url(@organization.id)
    mail(to: 'mapaverde@um.edu.uy, devops@data.org.uy', subject: 'Mapa Verde - Nueva organización')
  end

  def new_activity
    @activity = params[:activity]
    @url  =  admin_activity_url(@activity.id)
    mail(to: 'mapaverde@um.edu.uy, devops@data.org.uy', subject: 'Mapa Verde - Nueva Actividad')
  end
  def new_contact(contact)
    @contact = contact
    mail(to: 'mapaverde@um.edu.uy, devops@data.org.uy', subject: 'Mapa Verde - Nuevo Contacto')
  end
end
