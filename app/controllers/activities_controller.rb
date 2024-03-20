class ActivitiesController < ApplicationController
  def list
    @pagy_acts, @activities = pagy(Activity.where('starts > ?', Date.today).order(:starts), items: 3, page_param: :page_acts)
    respond_to do |format|
      format.html
      format.turbo_stream {
        logger.info "JSJSJSJSJS"
      }
    end
  end
end
