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
    if params[:id].is_number?
      @activity = Activity.where(id: params[:id], enabled: true).first
    else
      @activity = Activity.where(slug: params[:id], enabled: true).first
    end
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
    @organizations = {}
    @activities.each do |a|
      @organizations[a.id] = a.organizations.pluck(:name) + [a.other_responsibles]
    end
    @subjects = Subject.all.map {|z| {
      id: z.id,
      name: z.name,
      icon: z.icon.attached? ? url_for(z.icon) : '/images/icon_default.svg',
      color: z.color
    }}
  end
  def new
    @activity = Activity.new
  end
  def create
    @activity = Activity.new(activity_params)
    success = verify_recaptcha(action: 'create_activity', minimum_score: 0.8)
    checkbox_success = verify_recaptcha(model: @organization, site_key: Rails.application.credentials.recaptcha.site_key) unless success
    if success || checkbox_success
      @activity.save
      @activity = Activity.new
      @notice = {"mtype" => "success", "title" => "Se ha creado la actividad!", "body" => "Te estaremos comunicando su aprobación en cuanto revisemos la información, gracias"}
    else
      if !success
        @show_checkbox_recaptcha = true
        Rails.logger.warn("Post not saved because of a recaptcha score of #{recaptcha_reply['score']}")
        @message = "Ha habido un error en la creación de la actividad, por favor contacte a..."
        render json: @activity.errors.to_json, status: :unprocessable_entity
      end
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
