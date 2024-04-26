class ResourcesController < ApplicationController
  def index
    @active_filters = []
    if params['subjects'].present?
      @active_filters = params['subjects'].split(',')
      res = Resource.includes(:subjects).where('subjects.id': @active_filters).order(:created_at)
    else
      res = Resource.all.order(:created_at)
    end
    @subjects = Subject.all.map {|z| {
      value: z.id,
      name: z.name,
      icon: z.icon.attached? ? url_for(z.icon) : '/images/icon_default.svg'
    }}
    logger.info("\n\n\n#{}\n")
    @pagy, @resources = pagy(res, items: 6, page_param: :page)
    respond_to do |format|
      format.html
      format.turbo_stream {
        logger.info "\n\RESOURCES TURBO\n\n"
      }
    end
  end
  def show
    @resource = Resource.find(params[:id])
  end
end
