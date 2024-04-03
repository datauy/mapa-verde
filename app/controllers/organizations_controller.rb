class OrganizationsController < ApplicationController
  def list
  end
  def new
    @organization = Organization.new
  end
  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      redirect_to root_path, notice: "Actividad creada!"
    else
      render :new
    end
  end
  def organization_params
    params.require(:organization).permit(:name, :organization_type_id, :subject_id, :description, :website, :phone, :whatsapp, :email, :instagram, :tiktok, :twitter, :facebook, :snapchat, :other_network, :address, :region, :volunteers_description, :volunteers_url, :donations, :logo, :enabled, :state_id, :location_id, zone_ids: [], subject_ids: [], operation_ids: [])
  end
end
