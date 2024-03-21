class HomeController < ApplicationController
  def index
    @otype_options = Organization.otypes.keys
    @zone_options = Organization.includes(:zones).distinct.pluck(:'zones.name', :'zones.id')
    @subject_options = Organization.includes(:subjects).distinct.pluck(:'subjects.name', :'subjects.id')
    @action_options = Organization.includes(:activities).distinct.pluck(:'activities.title', :'activities.id')
    @total = Organization.all.count
    self.search
  end
  def search
    @organizations = []
    zone_ids = []
    @zones = {}
    orgs = Organization.
    includes(:zones)
    logger.info " \n\n\n PASA PARAMS \n\n\n\n #{params.inspect}"
    if params['otype'].present?
      logger.info "\n\n\n PASA OTYPE \n\n\n\n"
      orgs = orgs.where(otype: params['otype'])
    end
    if params['subject'].present?
      orgs = orgs.where(otype: params['subject'])
    end
    if params['actions'].present?
      orgs = orgs.where(otype: params['actions'])
    end
    if params['zones'].present?
      orgs = orgs.where(otype: params['zones'])
    end
    orgs.each do |o|
      org = o.as_json
      org.merge!(zones: o.zones.ids)
      zone_ids = zone_ids | o.zones.ids
      #logger.debug org.inspect
      @organizations.push org
    end
    Zone.find(zone_ids).each do |z|
      @zones[z.id] = z
    end
    @showing = orgs.count
    respond_to do |format|
      format.html
      format.turbo_stream {
        logger.info "\n\nTURBO HOME SEARCH\n\n"
      }
    end
  end
end
