class StaticPagesController < ApplicationController
  def home
    @organizations = []
    zone_ids = []
    @zones = {}
    @otypes = []
    Organization.
    includes(:zones).
    where(enabled: true).
    each do |o|
      org = o.as_json
      org.merge!(zones: o.zones.ids)
      zone_ids = zone_ids | o.zones.ids
      #logger.debug org.inspect
      @organizations.push org
      @otypes.push o.otype unless @otypes.include? o.otype
    end
    Zone.find(zone_ids).each do |z|
      @zones[z.id] = z
    end
    logger
    @pagy_acts, @activities = pagy(Activity.where('starts > ?', Date.today).order(:starts), items: 3, page_param: :page_acts)
    @pagy_news, @news = pagy(New.order(:created_at), items: 3, page_param: :page_news)
    respond_to do |format|
      format.html
      format.turbo_stream {
        logger.info "JSJSJSJSJS"
      }
  end
  end
  def about
  end
  def faqs
  end
  def thank_you
  end
  def other_actions
    @step = 0
  end
end
