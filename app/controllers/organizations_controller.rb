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
end
