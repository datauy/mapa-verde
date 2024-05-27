class ResourcesController < ApplicationController
  def index
    @active_filters = []
    if params['subjects'].present?
      @active_filters = params['subjects'].split(',')
      res = Resource.includes(:subjects).where('subjects.id': @active_filters).order(weight: 'ASC', created_at: 'DESC')
    else
      res = Resource.all.order(weight: 'ASC', created_at: 'DESC')
    end
    @subjects = Subject.all.map {|z| {
      value: z.id,
      name: z.name,
      icon: z.icon.attached? ? url_for(z.icon) : '/images/icon_default.svg'
    }}
    @pagy, @resources = pagy(res, items: 6, page_param: :page)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
  def show
    @resource = Resource.find(params[:id])
    @subjects = []
    @resource.subjects.each do |org|
      @subjects.push({
        name: org.name,
        icon: org.icon.attached? ? url_for(org.icon) : '/images/icon_default.svg'
      })
    end
  end
end
