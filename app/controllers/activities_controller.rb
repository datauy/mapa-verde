class ActivitiesController < ApplicationController
  def list
    @pagy_acts, @activities = pagy(Activity.where('starts > ?', Date.today).order(:starts), items: 3, page_param: :page_acts)
    respond_to do |format|
      format.html
      format.turbo_stream {
        logger.info "\n\nACTIVITIES TURBO\n\n"
      }
    end
  end
  def show
    @activity = Activity.find(params[:id])
  end
  def calendar

  end
  def new
    @activity = Activity.new
  end
  def create
    @activity = Activity.new(activity_params)
    logger.info activity_params.inspect
    if @activity.save
      @activity = Activity.new
      @message = "Se ha creado la actividad, estamos revisando los detalles para su publicación, gracias. Cualquier inconveniente no dude en contactarse al correo..."
    else
      logger.info(@activity.errors.inspect)
      @message = "Ha habido un error en la creación de la actividad, por favor contacte a..."
    end
    respond_to do |format|
      format.html
      format.turbo_stream {
        logger.info "\n\nACTIVITIES CREATE TURBO\n\n"
      }
    end
  end

  private

  def activity_params
    params["activity"]["zone_ids"].reject!{|a| a==""}
    params["activity"]["organization_ids"].reject!{|a| a==""}
    params["activity"]["subject_ids"].reject!{|a| a==""}
    params["activity"]["operation_ids"].reject!{|a| a==""}
    params.require(:activity).permit(:title, :description, :address, :starts, :ends, :subject_id, :image, state_ids: [], location_ids: [], zone_ids: [], organization_ids: [], subject_ids: [], operation_ids: [])
  end
end
