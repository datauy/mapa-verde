class StaticPagesController < ApplicationController
  def about
  end
  def contact
  end
  def contact_submit
    begin
      SysMailer.new_contact(contact_params).deliver
      redirect_to root_path, notice: {mtype: 'success',title:"Contacto enviado!"}
    rescue StandardError => e
      redirect_to contact_path, notice: {mtype: 'error', title: "Error en envío de contacto", body: "Por favor, verifica la información enviada o contacta a soporte@data.org.uy"}
    end
  end
  def get_involved
  end
  def contact_params
    params["static_pages"]["state_id"] = params["state_id"] if params["state_id"].present?
    params.require(:static_pages).permit(:contact_type, :organization, :activity,:name, :email,:phone,:message, :state_id)
  end
end
