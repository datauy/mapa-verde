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

    if @activity.save
      redirect_to root_path, notice: "Organización creada!"
    else
      render :new
    end
  end

  private

  def activity_params
    params.require(:activity).permit(:title, :description, :address, :starts, :ends, :subject_id, :image, state_ids: [], location_ids: [], organization_ids: [], subject_ids: [], operation_ids: [])
  end
end
