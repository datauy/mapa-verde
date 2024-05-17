class ActivitiesController < ApplicationController
  def list
    @starts = Date.today
    if params['starts'].present?
      @starts = params['starts']
    end
    @ends = (Date.today + 365)
    if params['ends'].present?
      @ends = params['ends']
    end
    @pagy_acts, @activities = pagy(
      Activity.where('(starts >= :starts and starts <= :ends) or (ends >= :starts and ends <= :ends)', starts: @starts, ends: @ends).where(enabled: true).order(:starts),
      items: 3,
      page_param: :page_acts,
      link_extra: 'data-turbo-stream=true',
      request_path: '/activities-list',
      )
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
  def show
    @activity = Activity.where(id: params[:id], enabled: true).first
    if @activity.nil?
      redirect_to root_path, notice: {mtype: 'error',title:"No existe la actividad", body:"La actividad a la que estás intentando acceder no está disponible"}
      return
    end
    @organizations = []
    @activity.organizations.each do |org|
      @organizations.push({
        name: org.name,
        icon: org.logo.attached? ? url_for(org.logo) : '/images/logo-default.svg'
      })
    end
    @subjects = []
    @activity.subjects.each do |org|
      @subjects.push({
        name: org.name,
        icon: org.icon.attached? ? url_for(org.icon) : '/images/icon_default.svg'
      })
    end
    @actions = []
    @activity.operations.each do |org|
      @actions.push({
        name: org.name,
        icon: org.icon.attached? ? url_for(org.icon) : '/images/icon_default.svg'
      })
    end

  end
  def calendar
    @activities = Activity.includes(:organizations).where(enabled: true)
    @organizations = @activities.map{|a| {a.id => a.organizations.pluck(:name)}}.first
    @subjects = Subject.all
  end
  def new
    @activity = Activity.new
  end
  def create
    logger.info "CREATE: #{activity_params.inspect}"
    @activity = Activity.new(activity_params)
    if @activity.save
      @activity = Activity.new
      @notice = {"mtype" => "success", "title" => "Se ha creado la actividad!", "body" => "Te estaremos comunicando su aprobación en cuanto revisemos la información, gracias"}
    else
      @message = "Ha habido un error en la creación de la actividad, por favor contacte a..."
      render json: @activity.errors.to_json, status: :unprocessable_entity
    end
  end

  private

  def activity_params

    params["activity"]["location_id"] = params["location_id"] if params["location_id"].present?
    params["activity"]["organization_ids"].reject!{|a| a==""}
    params["activity"]["subject_ids"].reject!{|a| a==""}
    params["activity"]["operation_ids"].reject!{|a| a==""}
    params.require(:activity).permit(:title, :description, :address, :starts, :ends, :subject_id, :image, :state_id, :location_id, :info_link, :other_responsibles, organization_ids: [], subject_ids: [], operation_ids: [])
  end
end
