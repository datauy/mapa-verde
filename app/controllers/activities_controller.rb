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

  def contact_params
    params.require(:activity).permit(:name, :email, :message)
  end
end
