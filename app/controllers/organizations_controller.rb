class OrganizationsController < ApplicationController
  def list
  end
  def new
    @organization = Organization.new
  end
  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      redirect_to root_path, {mtype: 'success',title:"Organización creada!", body:" Te estaremos comunicando su aprobación en cuanto revisemos la información, gracias"}
    else
      render :new
    end
  end
  def state_locations
    @locations = []
    if params[:state_id].present?
      @locations = Zone.where(parent_zone_id: params[:state_id]).order(:name).pluck(:name, :id)
    end
    respond_to do |format|
      format.turbo_stream
    end
  end
  def organization_params
    params["organization"]["zone_ids"].reject!{|a| a==""}
    params["organization"]["subject_ids"].reject!{|a| a==""}
    params["organization"]["operation_ids"].reject!{|a| a==""}
    params["organization"]["region"] = params["organization"]["region"].to_i
    params.require(:organization).permit(:name, :organization_type_id, :subject_id, :description, :website, :phone, :whatsapp, :email, :instagram, :tiktok, :twitter, :facebook, :snapchat, :other_network, :address, :region, :volunteers_description, :volunteers_url, :donations, :logo, :enabled, :state_id, :location_id, zone_ids: [], subject_ids: [], operation_ids: [])
  end
end
